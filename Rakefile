require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task ci: %i[spec standard]
task default: %i[spec standard:fix]
