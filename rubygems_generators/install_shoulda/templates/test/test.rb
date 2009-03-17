require File.dirname(__FILE__) + '/test_helper.rb'

class <%= gem_name.capitalize! %>Test < Test::Unit::TestCase
  context "A <%= gem_name %> instance" do
    setup do
    
    end
    
    should "run" do
      # raise "write your specs!"
    end
  end
end
