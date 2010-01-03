require 'rake/clean'
require 'hanna/rdoctask'
require 'rubygems'
require 'rake/gempackagetask'
require 'grancher'

begin
  require 'grancher/task'
  Grancher::Task.new do |g|
    g.branch = 'gh-pages'
    g.push_to = 'origin'
    g.directory 'html'
  end
rescue LoadError
  puts 'You should install the \'grancher\' gem if you wish to push to gh-pages'
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "trac4r"
    s.executables = "trac"
    s.summary = 'Ruby Client Library for Trac'
    s.email = "davidcopeland@naildrivin5.com"
    s.description = 'Basic ruby client library and command line interface for accessing Trac instances via its XML RPC API'
    s.authors = ['Niklas Cathro','David Copeland']
    s.add_dependency('rainbow', '>= 1.0.4')
    s.add_dependency('gli', '>= 1.1.0')
    s.has_rdoc = true
    s.extra_rdoc_files = ['README.rdoc','trac.rdoc']
    s.rdoc_options << '--title' << 'trac4r Trac Ruby Client' << '--main' << 'README.rdoc' << '-ri'
    s.require_paths << 'lib'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install jeweler"
end
CLOBBER.include('trac4r.gemspec')
CLOBBER.include('pkg')
CLOBBER.include('trac.rdoc')

Rake::RDocTask.new(:generate_rdoc) do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'Ruby interface to Trac'
end

task :default => :test

task :publish_rdoc => [:rdoc,:publish]

task :rdoc => [:bin_rdoc,:generate_rdoc]

task :bin_rdoc do |t|
  `bin/trac rdoc`
end
