# frozen_string_literal: true
require 'test_helper'
require 'tempfile'

class KyklosCommandTest < MiniTest::Test

  def setup
    @config = Tempfile.open(%W(schedule .rb))
    @config.write <<'CODE'
# Do nothing
CODE
  end

  def test_execute
    ARGV.clear
    ARGV << "-c"
    ARGV << @config.path
    ARGV << "--adapter=shoryuken"
    ARGV << "--adapter_args=https://sqs.ap-northeast-1.amazonaws.com/12345/kyklos.fifo"
    ARGV << "--identifier=identirier"
    Kyklos::CLI.stub_any_instance(:deploy, true) do
      Kyklos.run_command
    end
  end

end