require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "injectable/version"

task :gem => :build
task :build do
  system "gem build injectable.gemspec"
end

task :install => :build do
  system "sudo gem install injectable-#{Injectable::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{Injectable::VERSION} -m 'Tagging #{Injectable::VERSION}'"
  system "git push --tags"
  system "gem push injectable-#{Injectable::VERSION}.gem"
  system "rm injectable-#{Injectable::VERSION}.gem"
end

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
