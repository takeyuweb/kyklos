# frozen_string_literal: true
require 'kyklos/job_list'
require 'kyklos/job'
require 'kyklos/version'

module Kyklos

  module_function

  def parse(code)
    Kyklos::JobList.new(code)
  end

end
