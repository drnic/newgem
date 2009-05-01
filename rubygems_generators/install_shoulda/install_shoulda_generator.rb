
class InstallShouldaGenerator < RubiGen::Base
  attr_reader :gem_name, :module_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root = File.expand_path(destination_root)
    @gem_name = base_name
    @module_name  = @gem_name.gsub('-','_').camelize
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'test'
      m.directory 'tasks'

      m.template 'test/test.rb', "test/test_#{gem_name}.rb"
      m.template "test/test_helper.rb", "test/test_helper.rb"
      
      m.file_copy_each %w( shoulda.rake ), 'tasks'
    end
  end

  protected
    def banner
      <<-EOS
Install Shoulda testing support. 

Includes a rake task (tasks/shoulda.rake) to be loaded by the root Rakefile,
which provides a "test" task.

EOS
    end
end