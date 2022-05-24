# frozen_string_literal: true
require 'test_helper'

class JobListTest < MiniTest::Test

  def setup
    @schedule = <<'CODE'
rate '1 minutes' do
  puts 'Rate'
end
cron '* * * * * *' do
  puts 'Cron'
end
CODE
  end

  def test_initialize_without_code
    assert_instance_of(Kyklos::JobList, Kyklos::JobList.new)
  end

  def test_initialize_with_code
    assert_instance_of(Kyklos::JobList, Kyklos::JobList.new(@schedule))
  end

  def test_parse_jobs
    job_list = Kyklos::JobList.new(@schedule)
    assert_equal(2, job_list.jobs.values.size)
  end

  def test_cron
    job_list = Kyklos::JobList.new
    job_list.cron('* * * * * *'){ }
    assert_instance_of(Kyklos::Job::Cron, job_list.jobs.values.last)
  end

  def test_rate
    job_list = Kyklos::JobList.new
    job_list.rate('1 minutes'){ }
    assert_instance_of(Kyklos::Job::Rate, job_list.jobs.values.last)
  end

  def test_cron_returns_job_id
    job_list = Kyklos::JobList.new
    job_id = job_list.rate('1 minutes'){ }
    assert_instance_of(Kyklos::Job::Rate, job_list.jobs[job_id])
  end

  def test_as_option
    job_list = Kyklos::JobList.new
    job_list.cron('* * * * * *', as: 'cron_a'){ }
    assert_instance_of(Kyklos::Job::Cron, job_list.jobs[:cron_a])
  end

  def test_desc_option
    job_list = Kyklos::JobList.new
    job_id = job_list.cron('* * * * * *', desc: 'DESCRIPTION'){ }
    assert_equal('DESCRIPTION', job_list.jobs[job_id].description)
  end

  def test_bracket
    job_list = Kyklos::JobList.new
    job_id = job_list.rate('1 minutes'){ }
    assert_equal(job_list[job_id], job_list.jobs[job_id])
  end

  def test_run
    job_list = Kyklos::JobList.new
    processed = false
    job_list.cron('* * * * * *', as: :cron_a){ processed = true }
    job_list.run(:cron_a)
    assert(processed)
  end

end