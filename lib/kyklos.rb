# frozen_string_literal: true
require 'kyklos/job_list'
require 'kyklos/job'
require 'kyklos/adapters'
require 'kyklos/adapters/shoryuken_adapter'
require 'kyklos/cli'
require 'kyklos/version'
require 'optparse'

module Kyklos

  module_function

  def parse(code)
    Kyklos::JobList.new(code)
  end

  def run_command
    options = {}
    OptionParser.new do |opt|
      opt.version = Kyklos::VERSION
      opt.on('-c', '--config CONFIG') do |config|
        options[:config_path] = config
      end
      opt.on('--adapter ADAPTER_NAME') do |adapter|
        options[:adapter] = adapter
      end
      opt.on('--adapter_args arg1,args,arg3...', Array) do |adapter_args|
        options[:adapter_args] = adapter_args
      end
      opt.on('--identifier IDENTIFIER') do |identifier|
        options[:identifier] = identifier
      end
      opt.parse!(ARGV)
    end

    Kyklos::CLI.new(**options).deploy
  end
end
