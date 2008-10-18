Given %r{^a safe folder$} do
  @safe_folder = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.rm_rf   @safe_folder
  FileUtils.mkdir_p @safe_folder
end

Given %r{^an existing newgem scaffold \[called '(.*)'\]$} do |project_name|
  # TODO this is a combo of "a safe folder" and "newgem is executed ..." steps; refactor
  @safe_folder = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.rm_rf   @safe_folder
  FileUtils.mkdir_p @safe_folder
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir @safe_folder do
    newgem_stdout = "newgem.out"
    system "ruby #{newgem} #{project_name} > #{newgem_stdout}"
  end
  @project_name = project_name
end

When %r{^newgem is executed for project '(.*)' with no options$} do |project_name|
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir @safe_folder do
    @newgem_stdout = "newgem.out"
    system "ruby #{newgem} #{project_name} > #{@newgem_stdout}"
  end
end

When %r{^newgem is executed for project '(.*)' with options '(.*)'$} do |project_name, arguments|
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir @safe_folder do
    @newgem_stdout = "newgem.out"
    system "ruby #{newgem} #{arguments} #{project_name} > #{@newgem_stdout}"
  end
end

When %r{^'(.*)' generator is invoked with arguments '(.*)'$} do |generator, arguments|
  FileUtils.chdir(File.join(@safe_folder, @project_name)) do
    @executable_stdout = "#{generator}.out"
    system "ruby script/generate #{generator} #{arguments} > #{@executable_stdout}"
  end
end

When /^run executable '(.*)' with arguments '(.*)'$/ do |executable, arguments|
  FileUtils.chdir(@safe_folder) do
    @executable_stdout = "#{File.basename(executable)}.out"
    system "ruby #{executable} #{arguments} > #{@executable_stdout}"
  end
end

Then %r{^folder '(.*)' is created$} do |folder|
  FileUtils.chdir @safe_folder do
    File.exists?(folder).should be_true
  end
end

Then %r{^file '(.*)' is created$} do |file|
  FileUtils.chdir @safe_folder do
    File.exists?(file).should be_true
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
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/#{@executable_stdout}")
  actual_output.should match(/#{opt1}/)
  actual_output.should match(/#{opt2}/)
end


