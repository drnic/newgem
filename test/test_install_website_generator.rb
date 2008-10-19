require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestInstallWebsiteGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    bare_setup
  end
  
  def teardown
    bare_teardown
  end
  
  def test_generator_without_options
    name = "myapp"
    run_generator(generator_name, [name], sources)
    
    %w[index.txt index.html template.html.erb stylesheets/screen.css javascripts/rounded_corners_lite.inc.js].each do |file|
      assert_generated_file("website/#{file}")
    end
    assert_generated_file("config/website.yml")
    assert_generated_file("script/txt2html")
    assert_generated_file("tasks/website.rake")
  end
  
  private
  def sources
    [ RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__), "..", generator_path)),
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
