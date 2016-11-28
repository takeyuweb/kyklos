# frozen_string_literal: true

module Kyklos
  module Adapters
    class BaseAdapter

      def initialize(*args)

      end

      def assign_cloudwatchevents(job_id:, rule_name_prefix:,rule:)
        raise NotImplementedError
      end

      def unassign_cloudwatchevents(rule:, rule_name_prefix:)
        # no op
      end

    end
  end
end