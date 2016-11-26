# frozen_string_literal: true
require 'test_helper'
require 'tempfile'

class CLITest < Test::Unit::TestCase

  setup do
    @config = Tempfile.open(%W(schedule .rb))
    @config.write <<'CODE'
# Do nothing
CODE
  end

  def test_initialize
    assert_instance_of(Kyklos::CLI, Kyklos::CLI.new(@config.path))
  end

  def test_deploy
    cli = Kyklos::CLI.new(@config.path)
    cli.deploy
  end

end