require 'rbconfig'

class InstallWebsiteGenerator < RubiGen::Base

  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :shebang => DEFAULT_SHEBANG,
                  :author  => "TODO",
                  :email   => "TODO",
                  :theme   => 'plain_theme'

  attr_reader :gem_name, :module_name
  attr_reader :author, :email, :theme, :rubyforge_username

  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root   = File.expand_path(destination_root)
    @gem_name           = base_name
    @module_name        = @gem_name.gsub('-','_').camelize
    @rubyforge_username = ENV['RUBYFORGE_USERNAME'].nil? || ENV['RUBYFORGE_USERNAME'].empty? ? 'unknown' : ENV['RUBYFORGE_USERNAME']
    extract_options
  end

  def manifest
    windows            = (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)
    script_options     = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }

    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'website/javascripts'
      m.directory 'website/stylesheets'
      m.directory 'config'
      m.directory 'script'

      # Website
      m.template_copy_each %w( index.txt index.html ), "website"

      m.template "config/website.yml.sample.erb", "config/website.yml.sample"

      %w( txt2html ).each do |file|
        m.template "script/#{file}",        "script/#{file}", script_options
        m.template "script/win_script.cmd", "script/#{file}.cmd",
          :assigns => { :filename => file } if windows
      end

      m.dependency theme, [], :destination => destination_root
    end
  end

  protected
    def banner
      <<-EOS
Adds a website to a RubyGem (or any other project I guess.)

USAGE: #{$0} [options]
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      opts.on("-a", "--author=\"Your Name\"", String,
              "You. The author of this RubyGem. You name goes in in the website.",
              "Default: 'TODO'") { |x| options[:author] = x }
      opts.on("-e", "--email=your@email.com", String,
              "Your email for people to contact you.",
              "Default: nil") { |x| options[:author] = x }
      opts.on("-T", "--theme=theme_name", String,
              "Theme generator to use",
              "Default: plain_theme") { |x| options[:theme] = x }
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      @author = options[:author]
      @email  = options[:email]
      @theme  = options[:theme]
    end

    def github_username
      @github_username ||= begin
        require File.dirname(__FILE__) + '/../../lib/newgem/rubyforge-ext' unless Newgem.const_defined?("Rubyforge")
        rubyforge_config = Newgem::Rubyforge.new
        rubyforge_config.github_username
      end
    end

end
