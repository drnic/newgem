class ExecutableGenerator < RubiGen::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])
  
  default_options :shebang => DEFAULT_SHEBANG,
                  :author => nil
  
  attr_reader :bin_name, :author
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @bin_name     = args.shift
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

      # App stub
      m.template "app.rb",         "bin/#{bin_name}"
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
              "Default: none") { |options[:author]| }
    end
    
    def extract_options
      @author = options[:author]
    end
end