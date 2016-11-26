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
        # TODO: CloudWatch Eventsに登録済みだが手元のジョブリストにないものを削除
      end

      def put_jobs
        @job_list.each do |job_id, job|
          put_job(job_id, job)
        end
      end

      def put_job(job_id, job)
        rule = {
            name: eventname(job_id),
            event_pattern: '',
            state: 'DISABLED',
            description: job.description,
            schedule_expression: job.schedule_expression,
        }
        rule_arn = cloudwatchevents.put_rule(rule).rule_arn
        targets = adapter.cloudwatchevents_targets(
            job_id: job_id,
            rule_arn: rule_arn)
        cloudwatchevents.put_targets(
            rule: rule[:name],
            targets: targets
        )
        cloudwatchevents.enable_rule(name: rule[:name])
      end

      def prefix
        "kyslos-#{@identifier}-"
      end

      def eventname(job_id)
        "#{prefix}#{Digest::MD5.hexdigest(job_id.to_s)}"
      end

      def adapter
        adapter_klass = Kyklos::Adapters.const_get("#{@adapter.capitalize}Adapter")
        adapter_klass.new(*@adapter_args)
      end

  end
end