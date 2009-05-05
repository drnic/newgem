require File.dirname(__FILE__) + "/../../lib/newgem"

require 'cucumber'
require 'spec'

require 'pp'
require 'fileutils'
require 'rubygems' unless ENV['NO_RUBYGEMS']

Before do
  @tmp_root = File.dirname(__FILE__) + "/../../tmp"
  @home_path = File.expand_path(File.join(@tmp_root, "home"))
  FileUtils.rm_rf   @tmp_root
  FileUtils.mkdir_p @home_path
  ENV['HOME'] = @home_path
end

# code from test/test_generator_helper.rb
TMP_ROOT = File.dirname(__FILE__) + "/tmp" unless defined?(TMP_ROOT)

require 'rubigen'
require 'rubigen/helpers/generator_test_helper'
include RubiGen::GeneratorTestHelper

SOURCES = Dir[File.dirname(__FILE__) + "/../../*_generators"].map do |f|
  RubiGen::PathSource.new(:test, File.expand_path(f))
end