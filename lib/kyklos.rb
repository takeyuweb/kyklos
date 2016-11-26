# frozen_string_literal: true
require 'kyklos/job_list'
require 'kyklos/job'
require 'kyklos/adapters'
require 'kyklos/adapters/shoryuken_adapter'
require 'kyklos/cli'
require 'kyklos/version'

module Kyklos

  module_function

  def parse(code)
    Kyklos::JobList.new(code)
  end

end
