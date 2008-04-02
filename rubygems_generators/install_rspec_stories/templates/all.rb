require 'rubygems'
require 'spec/story'
$:.unshift(File.dirname(__FILE__) + '/../spec_helper')
require 'stories/steps/rubyfools_steps'

with_steps_for :rubyfools do
  run 'stories/sell_rubyfools.story'
end