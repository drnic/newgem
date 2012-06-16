RSpec::Matchers.define :contain do |expected|
  match do |actual|
    actual.index expected
  end
  
  failure_message_for_should do |actual|
    "expected #{actual.inspect} to contain #{expected.inspect}"
  end

  failure_message_for_should_not do |actual|
    "expected #{actual.inspect} not to contain #{expected.inspect}"
  end
end
