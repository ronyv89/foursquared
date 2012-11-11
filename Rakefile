require 'rspec/core/rake_task'
require "rake/tasklib"
require 'ci/reporter/rake/rspec'
require 'yard'
require 'yard/rake/yardoc_task'
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec => ["ci:setup:rspec"]) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec

desc "Analyze for code complexity"
task :metric_abc do
  puts `bundle exec metric_abc \`find lib/ -iname '*.rb'\``
end



YARD::Rake::YardocTask.new(:yard) do |y|
  y.options = ["--output-dir", "yardoc"]
end

namespace :yardoc do
  desc "generates yardoc files to yardoc/"
  task :generate => :yard do
    puts "Yardoc files generated at yardoc/"
  end
end
