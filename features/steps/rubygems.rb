Then /^gemspec builds the RubyGem successfully$/ do
  @stdout = File.expand_path(File.join(@tmp_root, "rake.out"))
  FileUtils.chdir(@active_project_folder) do
    system "gem build #{@project_name}.gemspec > #{@stdout}"
    gemspec = Dir['**/*.gem'].first
    gemspec.should_not be_nil
  end
end