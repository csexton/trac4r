require 'rake'
require 'rake/rdoctask'
require 'ftools'

Rake::RDocTask.new("doc") { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.template = ENV['template'] if ENV['template']
  rdoc.title = "Trac for Ruby"
  rdoc.options << '--line-number' << '--inline-source'
  rdoc.options << '--charset' << 'utf-8'
  ['lib/*.rb','*.rb'].each do |file|
    rdoc.rdoc_files.include(file)
  end
}

desc "Install trac4r on your system."
task :install do 
  default_dir = $:.first
  print "Type installation directory [#{default_dir}]: "
  dir = $stdin.gets
  dir = default_dir if dir.strip.empty?
  File.stat(dir.strip)
  install_dir = "#{dir}/trac4r"
  begin
    Dir.mkdir(install_dir)
  rescue => e
    $stderr.puts "Error creating directory #{install_dir}. Reason: #{e}"
    exit!
  end
  Dir.mkdir(install_dir+'/lib')
  File.syscopy("#{File.dirname(__FILE__)}/trac.rb",install_dir)
  puts "trac.rb => #{install_dir}/trac.rb"
  File.syscopy("#{File.dirname(__FILE__)}/Rakefile",install_dir)
  puts "Rakefile => #{install_dir}/Rakefile"
  Dir.entries("#{File.dirname(__FILE__)}/lib").each do |file|
    if file =~ /.*\.rb$/
      File.syscopy("#{File.dirname(__FILE__)}/lib/#{file}",install_dir+'/lib')
      puts "#{file} => #{install_dir}/lib/#{file}"
    end
  end
  puts "Successfully installed trac4r!"
end
