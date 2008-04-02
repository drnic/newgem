class InstallRspecStoriesGenerator < RubiGen::Base
  
  default_options :author => nil
  
  attr_reader :gem_name, :name
  
  def initialize(runtime_args, runtime_options = {})
    super
    @gem_name = base_name
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'stories/steps'

      m.template           'steps.rb', "stories/steps/#{gem_name}_steps.rb"
      m.template           'story.story', "stories/sell_#{gem_name}.story"
      m.template           'all.rb', "stories/all.rb"
      # Create stubs
      # m.template "template.rb",  "some_file_after_erb.rb"
      # m.file     "file",         "some_file_copied"
    end
  end

  protected
    def banner
      <<-EOS
Creates an RSpec story scaffold for this RubyGem.

USAGE: #{$0} #{spec.name}
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