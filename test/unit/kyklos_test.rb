# frozen_string_literal: true
require 'test_helper'

class KyklosTest < MiniTest::Test

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_that_it_has_a_version_number
    refute_nil Kyklos::VERSION
  end

  def test_parse
    schedule = <<'CODE'
rate '1 minutes' do
  puts 'Rate'
end
cron '* * * * * *' do
  puts 'Cron'
end
CODE
    assert_instance_of(Kyklos::JobList, Kyklos.parse(schedule))
  end

end