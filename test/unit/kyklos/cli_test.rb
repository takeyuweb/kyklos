# frozen_string_literal: true
require 'test_helper'
require 'tempfile'

# TODO: リソース操作のテスト

class CLITest < MiniTest::Test

  def setup
    @config = Tempfile.open(%W(schedule .rb))
    @config.write <<'CODE'
# Do nothing
CODE
  end

  def test_initialize
    assert_instance_of(Kyklos::CLI, Kyklos::CLI.new(config_path: @config.path, adapter: 'shoryuken'))
  end

  def test_deploy
    cli = Kyklos::CLI.new(config_path: @config.path, adapter: 'shoryuken')
    Aws.config[:cloudwatchevents] = {
        stub_responses: {
            list_rules: {
                rules: []
            }
        }
    }
    cli.deploy
  end

end