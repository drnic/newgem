require File.dirname(__FILE__) + "/../../lib/newgem"

require 'cucumber'
require 'spec'

require 'pp'
require 'fileutils'
require 'rubygems'

# code from test/test_generator_helper.rb
TMP_ROOT = File.dirname(__FILE__) + "/tmp" unless defined?(TMP_ROOT)

begin
  require 'rubigen'
rescue LoadError
  require 'rubygems'
  require 'rubigen'
end
require 'rubigen/helpers/generator_test_helper'
include RubiGen::GeneratorTestHelper

SOURCES = Dir[File.dirname(__FILE__) + "/../../*_generators"].map do |f|
  RubiGen::PathSource.new(:test, File.expand_path(f))
end

