begin
  require 'shoulda'
rescue LoadError
  require 'rubygems'
  require 'shoulda'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require '<%= gem_name %>'
