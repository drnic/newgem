require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestGenerateComponentGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    rubygems_setup
  end
  
  def teardown
    rubygems_teardown
  end
  
  def test_generator_without_options
    app_name = "myapp"
    run_generator('component_generator', [app_name], sources)
    assert_generated_file("generators/#{app_name}/#{app_name}_generator.rb")
    assert_generated_file("generators/#{app_name}/USAGE")
    assert_generated_file("test/test_#{app_name}_generator.rb")
    assert_generated_file("test/test_generator_helper.rb")
    assert_directory_exists("generators/#{app_name}/templates")
    assert_generated_class("generators/#{app_name}/#{app_name}_generator") do |body|
      # assert_has_method body, "initialize" # as_has_m cannot pickup initialize(...) only initialize
      assert_has_method body, "manifest"
    end
    assert_generated_class("test/test_#{app_name}_generator") do |body|
      assert_has_method body, "setup"
      assert_has_method body, "teardown"
      assert_has_method body, "test_generator_without_options"
      assert_has_method body, "sources"
      assert_has_method body, "generator_path"
    end
  end

  def test_generator_with_generator_type
    app_name = "myapp"
    gen_type = "fooapp"
    run_generator('component_generator', [app_name, gen_type], sources)
    
    assert_generated_file   "#{gen_type}_generators/#{app_name}/#{app_name}_generator.rb"
    assert_generated_file   "#{gen_type}_generators/#{app_name}/USAGE"
    assert_generated_file   "test/test_#{app_name}_generator.rb"
    assert_generated_file   "test/test_generator_helper.rb"
    assert_directory_exists "#{gen_type}_generators/#{app_name}/templates"
    assert_generated_class  "#{gen_type}_generators/#{app_name}/#{app_name}_generator" do |body|
      # assert_has_method body, "initialize" # as_has_m cannot pickup initialize(...) only initialize
      assert_has_method body, "manifest"
    end
    assert_generated_class "test/test_#{app_name}_generator" do |body|
      assert_has_method body, "setup"
      assert_has_method body, "teardown"
      assert_has_method body, "test_generator_without_options"
      assert_has_method body, "sources"
      assert_has_method body, "generator_path"
    end
  end

  private
  def sources
    [RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"../#{generator_path}"))
    ]
  end
  
  def generator_path
    "rubygems_generators"
  end
end
