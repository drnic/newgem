require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestInstallWebsiteGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    rubygems_setup
  end
  
  def teardown
    rubygems_teardown
  end
  
  def test_generator_without_options
    name = "myapp"
    run_generator(generator_name, ['.'], sources)
    
    %w[index.txt index.html template.rhtml stylesheets/screen.css javascripts/rounded_corners_lite.inc.js].each do |file|
      assert_generated_file("website/#{file}")
    end
    assert_generated_file("script/txt2html")
    assert_generated_file("tasks/website.rake")
  end
  
  def test_generator_in_subfolder
    name = "myapp"
    subfolder = "subfolder"
    run_generator(generator_name, ['.'], sources, {:destination => "#{APP_ROOT}/#{subfolder}"})
    
    %w[index.txt index.html stylesheets/screen.css javascripts/rounded_corners_lite.inc.js].each do |file|
      assert_generated_file("#{subfolder}/website/#{file}")
    end
    assert_generated_file("#{subfolder}/script/txt2html")
  end
  
  private
  def sources
    [ RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", generator_path)),
      RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__), "..", "newgem_theme_generators"))
    ]
  end
  
  def generator_path
    "newgem_generators"
  end
  
  def generator_name
    'install_website'
  end
end
