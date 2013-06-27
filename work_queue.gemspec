# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "work_queue"

Gem::Specification.new do |spec|
  spec.name          = "work_queue"
  spec.version       = WorkQueue::VERSION
  spec.authors       = ["Brian Kemper"]
  spec.email         = ["brian@staq.com"]
  spec.description   = %q{Work Queue with error handling}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/bkemper/work_queue"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*'] + Dir['tasks/**/*'] + Dir['test/**/*']
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

#  spec.add_runtime_dependency ""

  spec.add_development_dependency "bundler", "~> 1.3"
end
