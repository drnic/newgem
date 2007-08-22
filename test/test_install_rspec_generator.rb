require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestInstallRspecGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    bare_setup
  end
  
  def teardown
    bare_teardown
  end
  
  def test_generator_without_options
    name = File.basename(File.expand_path(APP_ROOT))
    run_generator('install_rspec', [name], sources)
    assert_directory_exists("spec")
    assert_directory_exists("tasks")
    assert_generated_file("spec/#{name}_spec.rb")
    assert_generated_file("spec/spec_helper.rb")
    assert_generated_file("tasks/rspec.rake")
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
