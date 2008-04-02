require 'rubygems'
require 'spec/story'
require File.dirname(__FILE__) + '/../spec/spec_helper'
require 'stories/steps/rubyfools_steps'

with_steps_for :rubyfools do
  run 'stories/sell_rubyfools.story'
end