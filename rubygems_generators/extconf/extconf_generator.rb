class ExtconfGenerator < RubiGen::Base

  default_options :author => nil

  attr_reader :name, :module_name, :test_module_name

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
    @module_name = name.camelcase
    @test_module_name = @module_name + "Extn"
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory "ext/#{name}"
      m.directory "tasks/extconf"
      m.directory "test"

      # Create stubs
      m.template "ext/c_file.c.erb",    "ext/#{name}/#{name}.c"
      m.template "ext/extconf.rb.erb",  "ext/#{name}/extconf.rb"
      m.template "test/test.rb.erb",    "test/test_#{name}_extn.rb"
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

    def add_options!(opts)
      # opts.separator ''
      # opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      # opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
end