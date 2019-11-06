require 'rubygems'
require 'rake'
require 'walruz/version'
require 'rspec/core/rake_task'
require 'yard'
require 'rdoc/task'

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
end

RDoc::Task.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rdoc.rdoc_dir = 'rdoc'


  rdoc.title = "walruz #{Walruz.version}"
end

task :test => :spec
task :default => :spec
