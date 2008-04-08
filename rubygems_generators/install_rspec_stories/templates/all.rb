require 'rubygems'
require 'spec/story'
require File.dirname(__FILE__) + '/../spec/spec_helper'
require 'stories/steps/<%= gem_name %>_steps'

with_steps_for :<%= gem_name %> do
  run 'stories/sell_<%= gem_name %>.story'
end
