begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'Shoulda'
  require 'Shoulda'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require '<%= gem_name %>'
