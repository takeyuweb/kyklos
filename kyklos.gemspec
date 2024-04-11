# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kyklos/version'

Gem::Specification.new do |spec|
  spec.name          = 'kyklos'
  spec.version       = Kyklos::VERSION
  spec.authors       = ['Yuichi Takeuchi']
  spec.email         = ['info@takeyu-web.com']

  spec.summary       = %q{You can use the Amazon CloudWatch Events to schedule jobs on Ruby.}
  spec.homepage      = 'https://github.com/takeyuweb/kyklos/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- test/unit/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-cloudwatchevents'
  spec.add_dependency 'aws-sdk-sqs'
  spec.add_dependency 'shoryuken'
  spec.add_dependency 'rexml'

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'minitest', '~> 5.15'
  spec.add_development_dependency 'minitest-stub_any_instance', '~> 1.0', '>= 1.0.3'

  spec.required_ruby_version = '>= 2.7'
end
