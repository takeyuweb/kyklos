# frozen_string_literal: true
module Kyklos
  module Job
    class Base

      def initialize(fields, closure)
        @fields = fields
        @closure = closure
      end

      def run
        @closure.call
      end

    end
  end
end