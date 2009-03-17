require File.dirname(__FILE__) + "/../../lib/newgem"

require 'cucumber'
require 'spec'

require 'pp'
require 'fileutils'
require 'rubygems' unless ENV['NO_RUBYGEMS']

# Following lines from original Rails cucumber generator. 
# Not sure how to translate/reuse etc yet.
# 
# # Sets up the Rails environment for Cucumber
# ENV["RAILS_ENV"] = "test"
# require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
# require 'cucumber/rails/world'
# Cucumber::Rails.use_transactional_fixtures
# 
# # Comment out the next line if you're not using RSpec's matchers (should / should_not) in your steps.
# require 'cucumber/rails/rspec'

# code from test/test_generator_helper.rb
TMP_ROOT = File.dirname(__FILE__) + "/tmp" unless defined?(TMP_ROOT)

require 'rubigen'
require 'rubigen/helpers/generator_test_helper'
include RubiGen::GeneratorTestHelper

SOURCES = Dir[File.dirname(__FILE__) + "/../../*_generators"].map do |f|
  RubiGen::PathSource.new(:test, File.expand_path(f))
end