# frozen_string_literal: true
module Kyklos
  module Job
    autoload :Base, 'kyklos/job/base'
    autoload :Cron, 'kyklos/job/cron'
    autoload :Rate, 'kyklos/job/rate'
  end
end