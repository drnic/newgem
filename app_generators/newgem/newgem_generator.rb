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
                    :disable_website => nil,
                    :test_framework  => 'test::unit',
                    :version     => '0.0.1'


  attr_reader :gem_name, :module_name
  attr_reader :version, :version_str, :author, :email

  # extensions/option
  attr_reader :test_framework
  attr_reader :bin_names_list
  attr_reader :disable_website
  attr_reader :manifest
  attr_reader :is_jruby

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @gem_name = base_name
    @module_name  = gem_name.camelize
    extract_options
  end

  def manifest
    # Use /usr/bin/env if no special shebang was specified
    script_options = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }
    windows        = (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)

    record do |m|
      # Root directory and all subdirectories.
      m.directory ''
      BASEDIRS.each { |path| m.directory path }

      m.directory "lib/#{gem_name}"

      # Root
      m.template_copy_each %w( History.txt License.txt Rakefile README.txt PostInstall.txt )
      m.file_copy_each     %w( setup.rb )

      # Default module for app
      m.template "module.rb",         "lib/#{gem_name}.rb"
      m.template "version.rb",        "lib/#{gem_name}/version.rb"

      # Config
      m.template_copy_each %w( hoe.rb requirements.rb ), "config"

      # Tasks
      m.file_copy_each %w( deployment.rake environment.rake website.rake ), "tasks"

      # Selecting a test framework
      case test_framework
      when "test::unit"
        m.template "test_helper.rb",    "test/test_helper.rb"
        m.template "test.rb",           "test/test_#{gem_name}.rb"
      when "rspec"
        m.dependency "install_rspec", [gem_name], :destination => destination_root, :collision => :force
      end

      # Website
      m.dependency "install_website", [gem_name],
         :author => author, :email => email, :destination => destination_root, :collision => :force unless disable_website

     # JRuby
     m.dependency "install_jruby", [gem_name], :destination => destination_root, :collision => :force if is_jruby

      # Executables
      for bin_name in bin_names_list
        m.dependency "executable", [bin_name], :destination => destination_root, :collision => :force
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
      # TODO --import_path
      # opts.on("-i", "--import_path=PATH", String,
      #         "Path where your files could be copied from.",
      #         "Default: none") { |x| options[:import_path] = x }
      opts.on("-j", "--jruby",
              "Use if gem is for jruby.") { |x| options[:jruby] = x }
      opts.on("-a", "--author=PATH", String,
              "Your name to be inserted into generated files.",
              "Default: ~/.rubyforge/user-config.yml[user_name]") { |x| options[:author] = x }
      opts.on("-r", "--ruby=path", String,
             "Path to the Ruby binary of your choice (otherwise scripts use env, dispatchers current path).",
             "Default: #{DEFAULT_SHEBANG}") { |x| options[:shebang] = x }
      opts.on("-T", "--test-with=TEST_FRAMEWORK", String,
              "Select your preferred testing framework.",
              "Options: test::unit (default), rspec.") { |x| options[:test_framework] = x }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
      opts.on("-V", "--set-version=YOUR_VERSION", String,
              "Version of the gem you are creating.",
              "Default: 0.0.1") { |x| options[:version] = x }
      opts.on("-W", "--website-disable",
              "Disables the generation of the website for your RubyGem.") { |x| options[:disable_website] = x }
      opts.on("--simple",
              "Creates a simple RubyGems scaffold.") { |x| }
    end

    def extract_options
      @version           = options[:version].to_s.split(/\./)
      @version_str       = @version.join('.')
      @author            = options[:author]
      @email             = options[:email]
      unless @author && @email
        require 'newgem/rubyforge'
        rubyforge_config = Newgem::Rubyforge.new
        @author ||= rubyforge_config.full_name
        @email  ||= rubyforge_config.email
      end
      @bin_names_list    = (options[:bin_name] || "").split(',')
      @disable_website   = options[:disable_website]

      @test_framework    = options[:test_framework] || "test::unit"
      @is_jruby          = options[:jruby]
    end

  # Installation skeleton.  Intermediate directories are automatically
  # created so don't sweat their absence here.
  BASEDIRS = %w(
    config
    doc
    lib
    script
    tasks
    test
    tmp
  )
end
