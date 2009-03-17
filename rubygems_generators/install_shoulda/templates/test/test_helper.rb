begin
  require 'shoulda'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  require 'shoulda'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require '<%= gem_name %>'
