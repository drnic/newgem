require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestNewgemGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  attr_reader :gem_name
  def setup
    bare_setup
    @gem_name = File.basename(File.expand_path(APP_ROOT))
  end

  def teardown
    bare_teardown
  end

  def test_newgem
    run_generator('newgem', [APP_ROOT], sources)

    assert_directory_exists "lib"
    assert_directory_exists "tasks"
    assert_directory_exists "test"

    %w[Rakefile README.rdoc History.txt Manifest.txt PostInstall.txt].each do |file|
      assert_generated_file(file)
    end

    assert_generated_file("lib/#{gem_name}.rb")

    ["test_helper.rb", "test_#{gem_name}.rb"].each do |file|
      assert_generated_file("test/#{file}")
    end

    %w[generate destroy console].each do |file|
      assert_generated_file("script/#{file}")
    end

    assert_generated_module("lib/#{gem_name}")

    assert_manifest_complete
  end

  def test_newgem_with_website
    run_generator('newgem', [APP_ROOT], sources, {:enable_website => true})

    %w[txt2html].each do |file|
      assert_generated_file("script/#{file}")
    end

    %w[index.txt index.html template.html.erb stylesheets/screen.css javascripts/rounded_corners_lite.inc.js].each do |file|
      assert_generated_file("website/#{file}")
    end

    assert_manifest_complete
  end

  def test_newgem_with_no_website
    run_generator('newgem', [APP_ROOT], sources)

    assert !File.exists?("#{APP_ROOT}/script/txt2html"), "No script/txt2html should be generated"
    assert !File.exists?("#{APP_ROOT}/website"), "No website folder should be generated"

    assert_manifest_complete
  end

  def test_newgem_with_executable
    @executables = ["some_executable", "another"]
    run_generator('newgem', [APP_ROOT], sources, {:bin_name => @executables.join(',')})

    @executables.each do |exec|
      assert_generated_file("bin/#{exec}")
    end

    assert_manifest_complete
  end

  def test_newgem_with_rspec
    run_generator('newgem', [APP_ROOT], sources, {:test_framework => "rspec"})

    assert_directory_exists("spec")
    assert_directory_exists("tasks")
    assert_generated_file("spec/#{gem_name}_spec.rb")
    assert_generated_file("spec/spec_helper.rb")
    assert_generated_file("tasks/rspec.rake")

    assert_manifest_complete
  end

  def test_newgem_with_jruby
    run_generator('newgem', [APP_ROOT], sources, {:jruby => true})

    assert_directory_exists("tasks")
    assert_generated_file("tasks/jruby.rake")

    assert_manifest_complete
  end

  def test_run_in_trunk_path_finds_parent_path_for_gem_name
    expected_gem_name = File.basename(File.expand_path(APP_ROOT))
    app_root = File.join(APP_ROOT, "trunk")
    FileUtils.mkdir_p app_root

    generator = run_generator('newgem', [app_root], sources)
    assert_equal(expected_gem_name, generator.gem_name)
  end
  
  def test_gem_name_should_come_from_project
    gen = build_generator('newgem', [APP_ROOT], sources, {})
    assert_equal 'myproject', gen.gem_name
  end
  
  def test_module_name_should_come_from_gem_name
    gen = build_generator('newgem', [APP_ROOT], sources, {})
    assert_equal 'Myproject', gen.module_name
  end
  
  def test_project_name_should_default_to_gem_name
    gen = build_generator('newgem', [APP_ROOT], sources, {})
    assert_equal 'myproject', gen.project_name
  end
  
  def test_project_name_can_be_overriden
    gen = build_generator('newgem', [APP_ROOT], sources, { :project => 'my_other_project' })
    assert_equal 'my_other_project', gen.project_name
  end
  
  def test_gem_name_does_not_change_if_project_name_is_overriden
    gen = build_generator('newgem', [APP_ROOT], sources, { :project => 'my_other_project' })
    assert_equal 'myproject', gen.gem_name
  end
  
  def test_module_name_does_not_change_if_project_name_is_overriden
    gen = build_generator('newgem', [APP_ROOT], sources, { :project => 'my_other_project' })
    assert_equal 'Myproject', gen.module_name
  end

  private
  def sources
    [ RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", generator_path)),
      RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__), "..", "newgem_generators")),
      RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__), "..", "newgem_theme_generators")),
      RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__), "..", "rubygems_generators"))
    ]
  end

  def generator_path
    "app_generators"
  end

  def assert_manifest_complete
    files = app_root_files.sort
    files.reject! { |file| File.directory?(file) }
    files.map! { |path| path.sub("#{APP_ROOT}/","") }
    files.reject! { |file| /^#{APP_ROOT}/ =~ file }
    manifest_files = File.open("#{APP_ROOT}/Manifest.txt","r") { |f| f.readlines.map { |line| line.strip } }
    assert_equal(files, manifest_files)
  end
end
