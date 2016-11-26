# frozen_string_literal: true
module Kyklos
  class JobList

    attr_reader :jobs

    def initialize(code = nil)
      @jobs = {}
      instance_eval(code) unless code.nil?
    end

    def [](id)
      @jobs[normalize_id(id)]
    end

    def run(id)
      self[id].run
    end

    def rate(fields, as: nil, &block)
      add_job(Kyklos::Job::Rate, fields, block, as: as)
    end

    def cron(fields, as: nil, &block)
      add_job(Kyklos::Job::Cron, fields, block, as: as)
    end

    private

      def add_job(klass, fields, block, as:)
        id = as || job_id(klass, fields)
        normalized_id = normalize_id(id)
        @jobs[normalized_id] = klass.new(fields, block)
        normalized_id
      end

      def job_id(klass, fields)
        [klass, fields].map(&:to_s).join('#')
      end

      def normalize_id(id)
        id.to_s.to_sym
      end

  end
end