begin
  require 'shoulda'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  require 'shoulda'
end

require 'rake/testtask'

desc "Run the shoulda test under /spec"
Rake::TestTask.new do |t|
   t.libs << "test"
   t.test_files = FileList['spec/*_spec.rb']
   t.verbose = true
end
