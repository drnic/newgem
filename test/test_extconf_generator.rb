require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestExtconfGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    bare_setup
  end

  def teardown
    bare_teardown
  end

  def test_generator_without_options
    name = "my_ext"
    run_generator('extconf', [name], sources)
    assert_directory_exists("ext/my_ext")
    assert_directory_exists("tasks/extconf")
    assert_generated_file("ext/my_ext/extconf.rb")
    assert_generated_file("ext/my_ext/my_ext.c")
    assert_generated_file("tasks/extconf.rake")
    assert_generated_file("tasks/extconf/my_ext.rake")
    assert_generated_file("test/test_my_ext_extn.rb")
    assert_generated_file(".autotest")
  end

  def test_generator_for_rspec_project
    name = "my_ext"
    FileUtils.mkdir_p(File.join(APP_ROOT, 'spec'))
    `touch #{APP_ROOT}/spec/spec_helper.rb`
    run_generator('extconf', [name], sources)
    assert_directory_exists("ext/my_ext")
    assert_directory_exists("tasks/extconf")
    assert_generated_file("ext/my_ext/extconf.rb")
    assert_generated_file("ext/my_ext/my_ext.c")
    assert_generated_file("tasks/extconf.rake")
    assert_generated_file("tasks/extconf/my_ext.rake")
    assert_generated_file("spec/my_ext_extn_spec.rb")
    assert_generated_file(".autotest")
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
