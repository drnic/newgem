class ExtconfGenerator < RubiGen::Base

  default_options :author => nil

  attr_reader :name, :module_name, :test_module_name

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
    @module_name = name.camelcase
    @test_module_name = @module_name + "Extn"
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory "ext/#{name}"
      m.directory "tasks/extconf"

      # Create stubs
      m.template "ext/c_file.c.erb",    "ext/#{name}/#{name}.c"
      m.template "ext/extconf.rb.erb",  "ext/#{name}/extconf.rb"
      if using_rspec?
        m.directory "spec"
        m.template "spec/spec.rb.erb", "spec/#{name}_extn_spec.rb"
      else
        m.directory "test"
        m.template "test/test.rb.erb",    "test/test_#{name}_extn.rb"
      end
      
      m.file     "tasks/extconf.rake",  "tasks/extconf.rake"
      m.file     "tasks/extconf_name.rake",  "tasks/extconf/#{name}.rake"

      m.file     "autotest.rb",         ".autotest"
      m.readme   "README.txt"
    end
  end

  protected
    def banner
      <<-EOS
Creates a C-extension via extconf.

The extension be automatically built before running tests,
and will be built when the RubyGem is installed by users.

USAGE: #{$0} #{spec.name} name
EOS
    end

    def using_rspec?
      !Dir[File.join(destination_root, 'spec')].empty?
    end
end