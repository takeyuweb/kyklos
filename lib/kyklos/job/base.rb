# frozen_string_literal: true
module Kyklos
  module Job
    class Base

      attr_reader :expression, :description

      def initialize(expression, closure, description: nil)
        @expression = expression
        @description = description
        @closure = closure
      end

      def run
        @closure.call
      end

      def schedule_expression
        "#{self.class.name.split('::').last.downcase}(#{expression})"
      end

    end
  end
end