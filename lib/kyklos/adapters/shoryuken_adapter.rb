# frozen_string_literal: true

# $ vi kyklos_worker.rb
# require 'kyklos'
# Kyklos::Adapters::ShoryukenAdapter::Worker.config_path = 'config/schedule.rb'
# Shoryuken.register_worker 'queue_name', Kyklos::Adapters::ShoryukenAdapter::Worker
#
# $ vi shoryuken.yml
# concurrency: 25
# delay: 25
# queues:
#     - [queue_name, 1]
#
# $ bundle exec shoryuken -r ./kyklos_worker.rb -C shoryuken.yml

require 'json'
require 'aws-sdk'
require 'digest/md5'
require 'shoryuken'

module Kyklos
  module Adapters
    class ShoryukenAdapter < BaseAdapter

      attr_reader :queue_url

      def initialize(*args)
        @queue_url = args[0]
      end

      def cloudwatchevents_targets(job_id:, rule_arn:)
        update_queue_policy(job_id, rule_arn)
        [
            {
                id: target_id(job_id),
                arn: target_arn,
                input: {
                    job_id: job_id
                }.to_json
            }
        ]
      end

      private

        def target_id(job_id)
          Digest::MD5.hexdigest(job_id.to_s)
        end

        def target_arn
          resp = sqs.get_queue_attributes(
              queue_url: @queue_url,
              attribute_names: ['QueueArn']
          )
          resp.attributes['QueueArn']
        end

        def update_queue_policy(job_id, rule_arn)
          policy_str = sqs.get_queue_attributes(
              queue_url: queue_url,
              attribute_names: ['Policy']
          ).attributes['Policy']

          policy = JSON.load(policy_str)
          unless policy
            policy = {
                'Version' => '2012-10-17',
                'Id' => "#{target_arn}/SQSDefaultPolicy",
                'Statement'=> []
            }
          end
          new_statement = {
              'Sid' => job_id.to_s,
              'Effect' => 'Allow',
              'Principal' => {
                  "AWS" => '*'
              },
              'Action' =>  'sqs:SendMessage',
              'Resource' => target_arn,
              'Condition' => {
                  'ArnEquals' => {
                      'aws:SourceArn' => rule_arn
                  }
              }
          }
          policy['Statement'] = add_statement(policy['Statement'], new_statement)

          sqs.set_queue_attributes(
              queue_url: queue_url,
              attributes: {
                  'Policy' =>  policy.to_json,
              },
          )
        end

        def add_statement(statements, new_sttement)
          index = statements.find_index{|statement| statement['Sid'] == new_sttement['Sid'] }
          if index
            statements[index] = new_sttement
          else
            statements.push(new_sttement)
          end
          statements
        end

        def sqs
          Aws::SQS::Client.new
        end


      class Worker
        include Shoryuken::Worker
        shoryuken_options auto_delete: true

        def self.config_path=(config_path)
          @@config_path = config_path
        end

        def self.config_path
          @@config_path
        end

        def perform(sqs_msg, body)
          data = JSON.load(body)
          job_id =data['job_id']
          if job_id
            kyklos.run(job_id)
          end
        end

        private

        def kyklos
          Kyklos.parse(File.read(self.class.config_path))
        end

      end

    end
  end
end