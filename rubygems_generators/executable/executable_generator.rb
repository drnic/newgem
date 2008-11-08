class ExecutableGenerator < RubiGen::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :shebang => DEFAULT_SHEBANG,
                  :author => nil

  attr_reader :bin_name, :module_name, :project_name, :author

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @bin_name     = args.shift
    @module_name  = @bin_name.classify
    @project_name = File.basename(File.expand_path(destination_root))
    extract_options
  end

  def manifest
    # Use /usr/bin/env if no special shebang was specified
    script_options     = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }
    dispatcher_options = { :chmod => 0755, :shebang => options[:shebang] }
    windows            = (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)

    record do |m|
      # Ensure bin folder exists
      m.directory "bin"
      m.directory "lib/#{bin_name}"

      # App stub
      m.template "bin/app.rb.erb", "bin/#{bin_name}"
      m.template "lib/app/cli.rb.erb", "lib/#{bin_name}/cli.rb"
      if using_rspec?
        m.directory "spec"
        m.template "spec/cli_spec.rb.erb", "spec/#{bin_name}_cli_spec.rb"
      else
        m.directory "test"
        m.template "test/test_cli.rb.erb", "test/test_#{bin_name}_cli.rb"
      end
    end
  end

  protected
    def banner
      <<-EOS
Create an executable Ruby script that is deployed
with this RubyGem.

USAGE: #{$0} generate bin_name"
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      opts.on("-a", "--author=\"Your Name\"", String,
              "Generated app file will include your name.",
              "Default: none") { |x| options[:author] = x }
    end

    def extract_options
      @author = options[:author]
    end
    
    def using_rspec?
      !Dir[File.join(destination_root, 'spec')].empty?
    end
end
