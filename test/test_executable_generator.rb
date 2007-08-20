require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestExecutableGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper
  
  def setup
    rubygems_setup
  end
  
  def teardown
    rubygems_teardown
  end
  
  def test_generator_without_options
    app_name = "myapp"
    run_generator('executable', [app_name], sources)
    assert_generated_file("bin/#{app_name}")
  end

  def sources
    [RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", generator_path))
    ]
  end
  
  def generator_path
    "rubygems_generators"
  end
end
