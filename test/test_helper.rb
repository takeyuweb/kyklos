# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kyklos'

require 'aws-sdk-cloudwatchevents'
require 'aws-sdk-sqs'

Aws.config.update(
    region: 'us-west-2',
    credentials: Aws::Credentials.new('DUMMY', 'DUMMY')
)

require 'test/unit'
