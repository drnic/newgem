Given %r{^a safe folder} do
  FileUtils.rm_rf   @tmp_root = File.dirname(__FILE__) + "/../../tmp"
  FileUtils.mkdir_p @tmp_root
  @lib_path = File.expand_path(File.dirname(__FILE__) + '/../../lib')
end

Given /^this project is active project folder/ do
  Given "a safe folder"
  @active_project_folder = File.expand_path(File.dirname(__FILE__) + "/../..")
end

Given /^env variable \$([\w_]+) set to '(.*)'/ do |env_var, value|
  ENV[env_var] = value
end

def force_local_lib_override(project_name = @project_name)
  rakefile = File.read(File.join(project_name, 'Rakefile'))
  File.open(File.join(project_name, 'Rakefile'), "w+") do |f|
    f << "$:.unshift('#{@lib_path}')\n"
    f << rakefile
  end
end

def setup_active_project_folder project_name
  @active_project_folder = File.join(@tmp_root, project_name)
  @project_name = project_name
end

Given /^'(.*)' folder is deleted/ do |folder|
  FileUtils.chdir @active_project_folder do
    FileUtils.rm_rf folder
  end
end

When %r{^'(.*)' generator is invoked with arguments '(.*)'$} do |generator, arguments|
  FileUtils.chdir(@active_project_folder) do
    if Object.const_defined?("APP_ROOT")
      APP_ROOT.replace(FileUtils.pwd)
    else 
      APP_ROOT = FileUtils.pwd
    end
    run_generator(generator, arguments.split(' '), SOURCES)
  end
end

When /^run executable '(.*)' with arguments '(.*)'$/ do |executable, arguments|
  @stdout = File.expand_path(File.join(@tmp_root, "executable.out"))
  FileUtils.chdir(@active_project_folder) do
    system "ruby #{executable} #{arguments} > #{@stdout}"
  end
end

When /^task 'rake (.*)' is invoked$/ do |task|
  @stdout = File.expand_path(File.join(@tmp_root, "tests.out"))
  FileUtils.chdir(@active_project_folder) do
    system "rake #{task} --trace > #{@stdout} 2> #{@stdout}"
  end
end

Then %r{^folder '(.*)' is created} do |folder|
  FileUtils.chdir @active_project_folder do
    File.exists?(folder).should be_true
  end
end

Then %r{^file '(.*)' (is|is not) created} do |file, is|
  FileUtils.chdir @active_project_folder do
    File.exists?(file).should(is == 'is' ? be_true : be_false)
  end
end

Then /^file matching '(.*)' is created$/ do |pattern|
  FileUtils.chdir @active_project_folder do
    Dir[pattern].should_not be_empty
  end
end

Then /^gem spec key '(.*)' contains \/(.*)\/$/ do |key, regex|
  FileUtils.chdir @active_project_folder do
    gem_file = Dir["pkg/*.gem"].first
    gem_spec = Gem::Specification.from_yaml(`gem spec #{gem_file}`)
    spec_value = gem_spec.send(key.to_sym)
    spec_value.to_s.should match(/#{regex}/)
  end
end
