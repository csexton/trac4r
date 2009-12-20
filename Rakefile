require 'rake/clean'
require 'hanna/rdoctask'
require 'rubygems'
require 'rake/gempackagetask'

$: << '../grancher/lib'
begin
  require 'grancher/task'
  Grancher::Task.new do |g|
    g.branch = 'gh-pages'
    g.push_to = 'origin'
    g.directory 'html'
  end
rescue LoadError
  #puts "you may install the optional gem 'grancher'"
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'Ruby interface to Trac'
end

spec = eval(File.read('trac4r.gemspec'))

Rake::GemPackageTask.new(spec) do |pkg|
end

task :default => :test

task :publish_rdoc => [:rdoc,:publish]
