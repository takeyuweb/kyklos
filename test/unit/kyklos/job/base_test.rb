# frozen_string_literal: true
require 'test_helper'

class BaseTest < Test::Unit::TestCase

  def test_run
    processed = false
    closure = ->() { processed = true }
    job = Kyklos::Job::Base.new('filds', closure)

    job.run
    assert(processed)
  end

end