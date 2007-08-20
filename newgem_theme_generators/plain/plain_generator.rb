class PlainGenerator < RubiGen::Base
  
  default_options :author  => "TODO",
                  :email   => "todo@todo.com"
  
  attr_reader :author, :email
  
  def initialize(runtime_args, runtime_options = {})
    super
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'website/javascripts'
      m.directory 'website/stylesheets'

      # Website
      m.template_copy_each %w( template.rhtml ), "website"
      m.file_copy_each     %w( stylesheets/screen.css javascripts/rounded_corners_lite.inc.js ), "website"
    end
  end

  protected
    def banner
      <<-EOS
Installs the plain blue-ish website theme for newgem's website framework.

USAGE: #{$0} #{spec.name}"
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      opts.on("-a", "--author=\"Your Name\"", String,
              "You. The author of this RubyGem. You name goes in in the website.",
              "Default: 'TODO'") { |options[:author]| }
      opts.on("-e", "--email=your@email.com", String,
              "Your email for people to contact you.",
              "Default: nil") { |options[:author]| }
    end
    
    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      @author = options[:author]
      @email  = options[:email]
    end
end