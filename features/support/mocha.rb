require "mocha"

World { |world| world.extend Mocha::Standalone }

Before do
  mocha_setup
end

After do
  begin
    mocha_verify
  ensure
    mocha_teardown
  end
end