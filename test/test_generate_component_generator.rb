require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestGenerateComponentGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    bare_setup
  end
  
  def teardown
    bare_teardown
  end
  
  def test_generator_without_options
    name = "genname"
    run_generator('component_generator', [name], sources)
    assert_generated_file("generators/#{name}/#{name}_generator.rb")
    assert_generated_file("generators/#{name}/USAGE")
    assert_generated_file("test/test_#{name}_generator.rb")
    assert_generated_file("test/test_generator_helper.rb")
    assert_directory_exists("generators/#{name}/templates")
    assert_generated_class("generators/#{name}/#{name}_generator") do |body|
      # assert_has_method body, "initialize" # as_has_m cannot pickup initialize(...) only initialize
      assert_has_method body, "manifest"
    end
    assert_generated_class("test/test_#{name}_generator") do |body|
      assert_has_method body, "setup"
      assert_has_method body, "teardown"
      assert_has_method body, "test_generator_without_options"
      assert_has_method body, "sources"
      assert_has_method body, "generator_path"
    end
  end

  def test_generator_with_generator_type
    name = "genname"
    gen_type = "fooapp"
    run_generator('component_generator', [name, gen_type], sources)
    
    assert_generated_file   "#{gen_type}_generators/#{name}/#{name}_generator.rb"
    assert_generated_file   "#{gen_type}_generators/#{name}/USAGE"
    assert_generated_file   "test/test_#{name}_generator.rb"
    assert_generated_file   "test/test_generator_helper.rb"
    assert_directory_exists "#{gen_type}_generators/#{name}/templates"
    assert_generated_class  "#{gen_type}_generators/#{name}/#{name}_generator" do |body|
      # assert_has_method body, "initialize" # as_has_m cannot pickup initialize(...) only initialize
      assert_has_method body, "manifest"
    end
    assert_generated_class "test/test_#{name}_generator" do |body|
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
