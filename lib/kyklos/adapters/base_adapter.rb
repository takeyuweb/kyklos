# frozen_string_literal: true

module Kyklos
  module Adapters
    class BaseAdapter

      def initialize(*args)

      end

      def cloudwatchevents_targets(job_id)
        raise NotImplementedError
      end

    end
  end
end