# frozen_string_literal: true
module Kyklos
  class JobList
    include Enumerable

    attr_reader :jobs

    def initialize(code = nil)
      @jobs = {}
      instance_eval(code) unless code.nil?
    end

    def [](id)
      @jobs[normalize_id(id)]
    end

    def each(&block)
      @jobs.each(&block)
    end

    def run(id)
      self[id].run
    end

    def rate(expression, as: nil, desc: nil, &block)
      add_job(Kyklos::Job::Rate, expression, block, as: as, desc: desc)
    end

    def cron(expression, as: nil, desc: nil, &block)
      add_job(Kyklos::Job::Cron, expression, block, as: as, desc: desc)
    end

    private

      def add_job(klass, expression, block, as:, desc:)
        id = as || job_id(klass, expression)
        normalized_id = normalize_id(id)
        @jobs[normalized_id] = klass.new(expression, block, description: desc)
        normalized_id
      end

      def job_id(klass, expression)
        [klass, expression].map(&:to_s).join('#')
      end

      def normalize_id(id)
        id.to_s.to_sym
      end

  end
end