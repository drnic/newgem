Given /^a safe folder$/ do
  @safe_folder = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.rm_rf   @safe_folder
  FileUtils.mkdir_p @safe_folder
end

When /^newgem is executed for project '(.*)'$/ do |project_name|
  newgem = File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  FileUtils.chdir @safe_folder do
    newgem_stdout = "newgem.out"
    system "ruby #{newgem} #{project_name} > #{newgem_stdout}"
  end
end

Then /^folder '(.*)' is created$/ do |folder|
  FileUtils.chdir @safe_folder do
    File.exists?(folder).should be_true
  end
end

Then /^file '(.*)' is created$/ do |file|
  FileUtils.chdir @safe_folder do
    File.exists?(file).should be_true
  end
end

Then /^output matches '(.*)'$/ do |file|
  expected_output = File.read(File.join(File.dirname(__FILE__) + "/../expected_outputs", file))
  actual_output = File.read(File.dirname(__FILE__) + "/../../tmp/newgem.out")
  actual_output.should == expected_output
end