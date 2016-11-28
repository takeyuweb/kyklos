# frozen_string_literal: true

module Kyklos
  module Adapters
    class BaseAdapter

      def initialize(*args)

      end

      def assign_cloudwatchevents(job_id:, rule:)
        raise NotImplementedError
      end

      def unassign_cloudwatchevents(rule:)
        raise NotImplementedError
      end

    end
  end
end