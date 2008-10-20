Given %r{^a safe folder} do
  FileUtils.rm_rf   $tmp_root = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.mkdir_p $tmp_root
end

Given /^this project is active project folder/ do
  FileUtils.rm_rf   $tmp_root = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.mkdir_p $tmp_root
  $active_project_folder = File.expand_path(File.dirname(__FILE__) + "/../..")
end

Given /^'(.*)' folder is deleted/ do |folder|
  FileUtils.chdir $active_project_folder do
    FileUtils.rm_rf folder
  end
end

Given %r{^an existing newgem scaffold \[called '(.*)'\]$} do |project_name|
  # TODO this is a combo of "a safe folder" and "newgem is executed ..." steps; refactor
  FileUtils.rm_rf   $tmp_root = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.mkdir_p $tmp_root
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir $tmp_root do
    @stdout = "newgem.out"
    system "ruby #{newgem} #{project_name} > #{@stdout}"
  end
  $active_project_folder = File.join($tmp_root, project_name)
end

Given /^project website configuration for safe folder on local machine$/ do
  $remote_folder = File.expand_path(File.join($tmp_root, 'website'))
  FileUtils.rm_rf   $remote_folder
  FileUtils.mkdir_p $remote_folder
  FileUtils.chdir $active_project_folder do
    # config_yml = { "host" => "localhost", "remote_dir" => $remote_folder }.to_yaml
    config_yml = { "remote_dir" => $remote_folder }.to_yaml
    config_path = File.join('config', 'website.yml')
    File.open(config_path, "w") { |io| io << config_yml }
  end  
end

When %r{^newgem is executed for project '(.*)' with no options$} do |project_name|
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir $tmp_root do
    @stdout = "newgem.out"
    system "ruby #{newgem} #{project_name} > #{@stdout}"
    $active_project_folder = File.join($tmp_root, project_name)
  end
end

When %r{^newgem is executed for project '(.*)' with options '(.*)'$} do |project_name, arguments|
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir $tmp_root do
    @stdout = "newgem.out"
    system "ruby #{newgem} #{arguments} #{project_name} > #{@stdout}"
    $active_project_folder = File.join($tmp_root, project_name)
  end
end

When %r{^'(.*)' generator is invoked with arguments '(.*)'$} do |generator, arguments|
  FileUtils.chdir($active_project_folder) do
    if Object.const_defined?("APP_ROOT")
      APP_ROOT.replace(FileUtils.pwd)
    else 
      APP_ROOT = FileUtils.pwd
    end
    run_generator(generator, arguments.split(' '), SOURCES)
  end
end

When /^run executable '(.*)' with arguments '(.*)'$/ do |executable, arguments|
  @stdout = File.expand_path(File.join($tmp_root, "executable.out"))
  FileUtils.chdir($active_project_folder) do
    system "ruby #{executable} #{arguments} > #{@stdout}"
  end
end

When /^run unit tests for test file '(.*)'$/ do |test_file|
  @stdout = File.expand_path(File.join($tmp_root, "tests.out"))
  FileUtils.chdir($active_project_folder) do
    system "ruby #{test_file} > #{@stdout}"
  end
end

When /^task 'rake (.*)' is invoked$/ do |task|
  @stdout = File.expand_path(File.join($tmp_root, "tests.out"))
  FileUtils.chdir($active_project_folder) do
    system "rake #{task} > #{@stdout} 2> #{@stdout}"
  end
end

Then %r{^folder '(.*)' is created} do |folder|
  FileUtils.chdir $active_project_folder do
    File.exists?(folder).should be_true
  end
end

Then %r{^remote folder '(.*)' is created} do |folder|
  FileUtils.chdir $remote_folder do
    File.exists?(folder).should be_true
  end
end

Then %r{^file '(.*)' (is|is not) created} do |file, is|
  FileUtils.chdir $active_project_folder do
    File.exists?(file).should(is == 'is' ? be_true : be_false)
  end
end

Then %r{^remote file '(.*)' (is|is not) created} do |file, is|
  FileUtils.chdir $remote_folder do
    File.exists?(file).should(is == 'is' ? be_true : be_false)
  end
end

Then /^file matching '(.*)' is created$/ do |pattern|
  FileUtils.chdir $active_project_folder do
    Dir[pattern].should_not be_empty
  end
end

Then %r{^output same as contents of '(.*)'$} do |file|
  expected_output = File.read(File.join(File.dirname(__FILE__) + "/../expected_outputs", file))
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/#{@stdout}")
  actual_output.should == expected_output
end

Then %r{^(does|does not) invoke generator '(.*)'$} do |does_invoke, generator|
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/#{@stdout}")
  does_invoke == "does" ?
    actual_output.should(match(/dependency\s+#{generator}/)) :
    actual_output.should_not(match(/dependency\s+#{generator}/))
end

Then /^help options '(.*)' and '(.*)' are displayed$/ do |opt1, opt2|
  actual_output = File.read(@stdout)
  actual_output.should match(/#{opt1}/)
  actual_output.should match(/#{opt2}/)
end

Then /^output matches \/(.*)\/$/ do |regex|
  actual_output = File.read(@stdout)
  actual_output.should match(/#{regex}/)
end

Then /^all (\d+) tests pass$/ do |expected_test_count|
  expected = %r{^#{expected_test_count} tests, \d+ assertions, 0 failures, 0 errors}
  actual_output = File.read(@stdout)
  actual_output.should match(expected)
end

Then /^yaml file '(.*)' contains (\{.*\})/ do |file, yaml|
  FileUtils.chdir $active_project_folder do
    yaml = eval yaml
    yaml.should == YAML.load(File.read(file))
  end
end

Then /^gem spec key '(.*)' contains '(.*)'$/ do |key, value|
  FileUtils.chdir $active_project_folder do
    gem_file = Dir['pkg/newgem-*.gem'].first
    gem_spec = Gem::Specification.from_yaml(`gem spec #{gem_file}`)
    spec_value = gem_spec.send(key.to_sym)
    spec_value.to_s.should match(/#{value}/)
  end
end