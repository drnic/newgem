require 'rbconfig'

class NewgemGenerator < RubiGen::Base

  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options   :shebang => DEFAULT_SHEBANG,
                    :bin_name    => nil,
                    :email       => nil,
                    :author      => nil,
                    :import_path => nil,
                    :jruby       => nil,
                    :enable_website => nil,
                    :test_framework  => 'test_unit',
                    :version     => '0.0.1'


  attr_reader :gem_name, :module_name, :project_name
  attr_reader :version, :version_str, :author, :email, :project_url

  # extensions/option
  attr_reader :test_framework
  attr_reader :bin_names_list
  attr_reader :enable_website, :enable_cucumber
  attr_reader :manifest
  attr_reader :is_jruby

  def initialize(runtime_args, runtime_options = {})
    super(config_args_and_runtime_args(runtime_args), runtime_options)
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @gem_name = base_name
    @module_name  = gem_name.gsub('-','_').camelize
    @project_name = @gem_name
    @github_username = 'FIXME'
    @project_url  = 'http://github.com/#{github_username}/#{project_name}'
    extract_options
  end

  def manifest
    # Use /usr/bin/env if no special shebang was specified
    script_options = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }
    windows        = (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)

    record do |m|
      # Root directory and all subdirectories.
      m.directory ''
      m.directory "lib/#{gem_name}"
      m.directory 'script'
      m.directory 'tasks'


      # Root
      m.template_copy_each %w( History.txt Rakefile README.rdoc PostInstall.txt )

      # Default module for app
      m.template "lib/module.rb",         "lib/#{gem_name}.rb"

      # Selecting a test framework
      case test_framework
      when "test_unit"
        m.dependency "install_test_unit", [gem_name], :destination => destination_root, :collision => :force
      when "rspec"
        m.dependency "install_rspec", [gem_name], :destination => destination_root, :collision => :force
      when "shoulda"
        m.dependency "install_shoulda", [gem_name], :destination => destination_root, :collision => :force
      end

      # Website
      m.dependency "install_website", [gem_name],
         :author => author, :email => email, :destination => destination_root, :collision => :force if enable_website

      # JRuby
      m.dependency "install_jruby", [gem_name], :destination => destination_root, :collision => :force if is_jruby

      # Executables
      for bin_name in bin_names_list
        m.dependency "executable", [bin_name], :destination => destination_root, :collision => :force
      end
      
      for generator in @install_generators
        m.dependency "install_#{generator}", [], :destination => destination_root, :collision => :force
      end
      
      m.dependency "install_rubigen_scripts", [destination_root, "rubygems", "newgem", "newgem_theme"], :shebang => options[:shebang], :collision => :force

      %w( console ).each do |file|
        m.template "script/#{file}.erb",        "script/#{file}", script_options
        m.template "script/win_script.cmd", "script/#{file}.cmd",
          :assigns => { :filename => file } if windows
      end

      m.write_manifest "Manifest.txt"

      m.readme "readme"
    end
  end

  protected
    def usage(message = usage_message)
      puts @option_parser
      exit
    end
  
    def banner
      <<-EOS
Take any library or Rails plugin or command line application,
gemify it, and easily share it with the Ruby world.

Usage: #{File.basename $0} /path/to/your/app [options]
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      opts.on("-b", "--bin-name=BIN_NAME[,BIN_NAME2]", String,
              "Sets up executable scripts in the bin folder.",
              "Default: none") { |x| options[:bin_name] = x }
      opts.on("-e", "--email=PATH", String,
              "Your email to be inserted into generated files.",
              "Default: ~/.rubyforge/user-config.yml[email]") { |x| options[:email] = x }
      opts.on("-i", "--install=generator", String,
              "Installs a generator called install_<generator>.",
              "For example, '-i cucumber' runs the install_cucumber generator.",
              "Can be used multiple times for different generators.",
              "Cannot be used for generators that require argumnts.",
              "Default: none") do |generator|
                options[:install] ||= []
                options[:install] << generator
              end
      opts.on("-j", "--jruby",
              "Use if gem is for jruby.") { |x| options[:jruby] = x }
      opts.on("-a", "--author=PATH", String,
              "Your name to be inserted into generated files.",
              "Default: ~/.rubyforge/user-config.yml[user_name]") { |x| options[:author] = x }
      opts.on("-p", "--project=PROJECT", String,
              "Rubyforge project name for the gem you are creating.",
              "Default: same as gem name") { |x| options[:project] = x }
      opts.on("-r", "--ruby=path", String,
             "Path to the Ruby binary of your choice (otherwise scripts use env, dispatchers current path).",
             "Default: #{DEFAULT_SHEBANG}") { |x| options[:shebang] = x }
      opts.on("-T", "--test-with=TEST_FRAMEWORK", String,
              "Select your preferred testing framework.",
              "Options: test_unit (default), rspec.") { |x| options[:test_framework] = x }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
      opts.on("-V", "--set-version=YOUR_VERSION", String,
              "Version of the gem you are creating.",
              "Default: 0.0.1") { |x| options[:version] = x }
      opts.on("-w", "--enable-website",
              "Enable the generation of the website for your RubyGem.",
              "Same as '-i website'") { |x| options[:enable_website] = x }
      opts.on("--simple",
              "Creates a simple RubyGems scaffold.") { |x| }
    end

    def extract_options
      @version           = options[:version].to_s.split(/\./)
      @version_str       = @version.join('.')
      @author            = options[:author]
      @email             = options[:email]
      unless @author && @email
        require File.dirname(__FILE__) + '/../../lib/newgem/rubyforge-ext' unless Object.const_defined?("Newgem") && Newgem.const_defined?("Rubyforge")
        rubyforge_config = Newgem::Rubyforge.new
        @author ||= rubyforge_config.full_name
        @email  ||= rubyforge_config.email
      end
      @bin_names_list     = (options[:bin_name] || "").split(',')
      @enable_website     = options[:enable_website]
      @test_framework     = options[:test_framework] || "test_unit"
      @is_jruby           = options[:jruby]
      @project_name       = options[:project] if options.include?(:project)
      @install_generators = options[:install] || []
      @enable_cucumber    = @install_generators.include?('cucumber')
    end
    
    # first attempt to merge config args (single string) and runtime args
    def config_args_and_runtime_args(runtime_args)
      newgem_config = File.expand_path(File.join(ENV['HOME'], '.newgem.yml'))
      if File.exists?(newgem_config)
        config = YAML.load(File.read(newgem_config))
        if config_args = (config["default"] || config[config.keys.first])
          return config_args.split(" ") + runtime_args
        end
      end
      runtime_args
    end
end
