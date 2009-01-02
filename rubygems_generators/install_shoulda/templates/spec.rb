require File.dirname(__FILE__) + '/spec_helper.rb'

class <%= gem_name.capitalize! %>Spec < Test::Unit::TestCase
  context "A <%= gem_name %> instance" do
    setup do
    
    end
    
    should "run" do
      raise "write your specs!"
    end
  end
end
