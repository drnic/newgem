Given %r{^a safe folder} do
  $tmp_root = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.rm_rf   $tmp_root
  FileUtils.mkdir_p $tmp_root
end

Given %r{^an existing newgem scaffold \[called '(.*)'\]$} do |project_name|
  # TODO this is a combo of "a safe folder" and "newgem is executed ..." steps; refactor
  $tmp_root = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.rm_rf   $tmp_root
  FileUtils.mkdir_p $tmp_root
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir $tmp_root do
    newgem_stdout = "newgem.out"
    system "ruby #{newgem} #{project_name} > #{newgem_stdout}"
  end
  @project_name = project_name
end

Given /^project website configuration for safe folder on local machine$/ do
  FileUtils.chdir $tmp_root do
    $website_root = File.expand_path('website')
    FileUtils.rm_rf   $website_root
    FileUtils.mkdir_p $website_root
    # config_yml = { "host" => "localhost", "remote_dir" => $website_root }.to_yaml
    config_yml = { "remote_dir" => $website_root }.to_yaml
    config_path = File.join(@project_name, 'config', 'website.yml')
    File.open(config_path, "w") { |io| io << config_yml }
  end  
end

When %r{^newgem is executed for project '(.*)' with no options$} do |project_name|
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir $tmp_root do
    @newgem_stdout = "newgem.out"
    system "ruby #{newgem} #{project_name} > #{@newgem_stdout}"
  end
end

When %r{^newgem is executed for project '(.*)' with options '(.*)'$} do |project_name, arguments|
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir $tmp_root do
    @newgem_stdout = "newgem.out"
    system "ruby #{newgem} #{arguments} #{project_name} > #{@newgem_stdout}"
  end
end

When %r{^'(.*)' generator is invoked with arguments '(.*)'$} do |generator, arguments|
  FileUtils.chdir(File.join($tmp_root, @project_name)) do
    if Object.const_defined?("APP_ROOT")
      APP_ROOT.replace(FileUtils.pwd)
    else 
      APP_ROOT = FileUtils.pwd
    end
    run_generator(generator, arguments.split(' '), SOURCES)
  end
end

When /^run executable '(.*)' with arguments '(.*)'$/ do |executable, arguments|
  FileUtils.chdir($tmp_root) do
    @stdout = "#{File.basename(executable)}.out"
    system "ruby #{executable} #{arguments} > #{@stdout}"
  end
end

When /^run unit tests for test file '(.*)'$/ do |test_file|
  @test_stdout = File.expand_path(File.join($tmp_root, "tests.out"))
  FileUtils.chdir(File.join($tmp_root, @project_name)) do
    system "ruby #{test_file} > #{@test_stdout}"
  end
end

When /^rake task '(.*)' is invoked$/ do |task|
  @rake_stdout = File.expand_path(File.join($tmp_root, "tests.out"))
  FileUtils.chdir(File.join($tmp_root, @project_name)) do
    system "rake #{task} > #{@rake_stdout}"
  end
end

Then %r{^folder '(.*)' is created} do |folder|
  FileUtils.chdir $tmp_root do
    File.exists?(folder).should be_true
  end
end

Then %r{^file '(.*)' (is|is not) created} do |file, is|
  FileUtils.chdir $tmp_root do
    File.exists?(file).should(is == 'is' ? be_true : be_false)
  end
end

Then %r{^output matches '(.*)'$} do |file|
  expected_output = File.read(File.join(File.dirname(__FILE__) + "/../expected_outputs", file))
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/#{@newgem_stdout}")
  actual_output.should == expected_output
end

Then %r{^invokes generator '(.*)'$} do |generator|
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/#{@newgem_stdout}")
  actual_output.should match(/dependency\s+#{generator}/)
end

Then %r{^does not invoke generator '(.*)'$} do |generator|
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/#{@newgem_stdout}")
  actual_output.should_not match(/dependency\s+#{generator}/)
end

Then /^help options '(.*)' and '(.*)' are displayed$/ do |opt1, opt2|
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/#{@stdout}")
  actual_output.should match(/#{opt1}/)
  actual_output.should match(/#{opt2}/)
end

Then /^output matches \/(.*)\/$/ do |regex|
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/#{@stdout}")
  actual_output.should match(/#{regex}/)
end

Then /^all (\d+) tests pass$/ do |expected_test_count|
  expected = %r{^#{expected_test_count} tests, \d+ assertions, 0 failures, 0 errors}
  actual_output = File.read(@test_stdout)
  actual_output.should match(expected)
end
