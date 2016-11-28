# frozen_string_literal: true

require 'aws-sdk'
require 'digest/md5'
require 'pp'

module Kyklos
  class CLI
    attr_reader :config_path, :job_list

    def initialize(config_path:, adapter:, adapter_args: [], identifier: 'default')
      @config_path = config_path.to_s
      @adapter = adapter
      @adapter_args = adapter_args
      @identifier = identifier
      @job_list = Kyklos.parse(File.read(config_path))
    end

    def deploy
      cleanup
      put_jobs
    end

    private

      def cloudwatchevents
        @cloudwatchevents ||= Aws::CloudWatchEvents::Client.new
      end

      def cleanup
        names = eventnames
        find_rules.each do |rule|
          unless names.include?(rule.name)
            remove_job(rule)
          end
        end
      end

      def put_jobs
        job_list.each do |job_id, job|
          put_job(job_id, job)
        end
      end

      def put_job(job_id, job)
        rule_params = {
            name: eventname(job_id),
            event_pattern: '',
            state: 'DISABLED',
            description: [@identifier, job.description].compact.join(': '),
            schedule_expression: job.schedule_expression,
        }
        cloudwatchevents.put_rule(rule_params)
        rule = cloudwatchevents.describe_rule(name: rule_params[:name])
        targets = adapter.assign_cloudwatchevents(
            job_id: job_id,
            rule: rule)
        cloudwatchevents.put_targets(
            rule: rule.name,
            targets: targets
        )
        cloudwatchevents.enable_rule(name: rule.name)
      end

      def remove_job(rule)
        adapter.unassign_cloudwatchevents(rule: rule)

        target_ids = find_targets(rule.name).map(&:id)
        unless target_ids.empty?
          cloudwatchevents.remove_targets(rule: rule.name, ids: target_ids)
        end
        cloudwatchevents.delete_rule(name: rule.name)
      end

      def prefix
        "kyslos-#{"#{@identifier}/#{Digest::MD5.hexdigest(@identifier)}".sum}-"
      end

      def eventname(job_id)
        "#{prefix}#{Digest::MD5.hexdigest(job_id.to_s)}"
      end

      def eventnames
        job_list.each.map { |job_id, _job| eventname(job_id) }
      end

      def adapter
        adapter_klass = Kyklos::Adapters.const_get("#{@adapter.capitalize}Adapter")
        adapter_klass.new(*@adapter_args)
      end

      def find_rules
        list_rules = ->(next_token) do
          resp = cloudwatchevents.
              list_rules(name_prefix: prefix,
                         next_token: next_token)
          if resp.next_token
            resp.rules + list_rules.call(next_token)
          else
            resp.rules
          end
        end
        list_rules.call(nil)
      end

      def find_targets(rule_name)
        list_targets = ->(next_token) do
          resp = cloudwatchevents.
              list_targets_by_rule(rule: rule_name,
                                   next_token: next_token)
          if resp.next_token
            resp.targets + list_targets.call(next_token)
          else
            resp.targets
          end
        end
        list_targets.call(nil)
      end

  end
end