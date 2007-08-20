class ApplicationGeneratorGenerator < RubiGen::Base
  default_options 
  
  attr_reader :name, :class_name, :generator_path
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name           = args.shift
    @class_name     = "#{name}_generator".camelize
    @generator_path = "app_generators"
    extract_options
  end

  def manifest
    path = "#{generator_path}/#{name}"
    record do |m|
      # Ensure appropriate generators folder exists
      m.directory "#{path}/templates"
      m.directory "bin"
      m.directory "test"

      # Generator stub
      m.template "generator.rb",              "#{path}/#{name}_generator.rb"
      m.template "test.rb",                   "test/test_#{name}_generator.rb"
      m.file     "test_generator_helper.rb",  "test/test_generator_helper.rb"
      m.file     "usage",                     "#{path}/USAGE"
      m.template "bin",                       "bin/#{name}"
      m.readme   'readme'
    end
  end

  protected
    def banner
      <<-EOS
Creates a application generator stub within your RubyGem.

Application Generators are used to create new applications
from scratch, and create the default scaffolding for
an application (directories) plus any starter files
that are useful to developers.

USAGE: #{$0} #{spec.name} name
EOS
    end
    
    def add_options!(opts)
      # opts.separator ''
      # opts.separator 'Options:'
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Generated app file will include your name.",
      #         "Default: none") { |options[:author]| }
    end
    
    def extract_options
    end

end