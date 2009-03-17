module CommonHelpers
  def in_tmp_folder(&block)
    FileUtils.chdir(@tmp_root, &block)
  end

  def in_project_folder(&block)
    project_folder = @active_project_folder || @tmp_root
    FileUtils.chdir(project_folder, &block)
  end

  def in_home_folder(&block)
    FileUtils.chdir(@home_path, &block)
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
  
  def project_name
    in_project_folder { return File.basename(File.expand_path(".")) }
  end
  
  def pipe_stdout_and_stderr_to(path, &block)
    old_stdout, old_stderr = $stdout, $stderr
    $stderr = $stdout = StringIO.new

    yield

    $stdout.rewind
    File.open(path, "w") do |f|
      f << $stdout.read
    end
    $stdout, $stderr = old_stdout, old_stderr
  end
end

World { |world| world.extend CommonHelpers }