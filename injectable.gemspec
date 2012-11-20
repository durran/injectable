# encoding: utf-8
require "./lib/injectable/version"

Gem::Specification.new do |s|
  s.name         = "injectable"
  s.version      = Injectable::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Durran Jordan"]
  s.email        = ["durran@gmail.com"]
  s.summary      = "Dead simple Ruby dependency injection"
  s.description  = s.summary
  s.files        = Dir.glob("lib/**/*") + %w(README.md Rakefile)
  s.require_path = "lib"

  s.add_dependency("activesupport", ["~> 3"])
end
