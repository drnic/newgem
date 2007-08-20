require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestInstallJrubyGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    # see rubygems_setup
  end
  
  def teardown
    # see rubygems_teardown
  end
  
  def test_generator_without_options
    name = "myapp"
    run_generator('install_jruby', [name], sources)
    assert_generated_file("tasks/jruby.rake")
  end
  
  private
  def sources
    [RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", generator_path))
    ]
  end
  
  def generator_path
    "rubygems_generators"
  end
end
