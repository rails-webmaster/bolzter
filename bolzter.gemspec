# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bolzter/version'

Gem::Specification.new do |spec|
  spec.name          = "bolzter"
  spec.version       = Bolzter::VERSION
  spec.authors       = ["John"]
  spec.email         = ["rails.john.smith@gmail.com"]
  spec.summary       = "Interface to Bolzter APIs"
  spec.description   = "This gem supports an interface to Bolzter APIs"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bolzter.gemspec", "lib/bolzter.rb", "lib/bolzter/version.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
