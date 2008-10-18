class FeatureGenerator < RubiGen::Base
  attr_reader :plural_name, :singular_name, :class_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    @name          = args.shift
    @plural_name   = @name.pluralize
    @singular_name = @name.singularize
    @class_name    = @name.classify
  end

  def manifest
    record do |m|
      m.directory 'features/steps'
      m.template  'feature.erb', "features/manage_#{plural_name}.feature"
      m.template  'steps.erb', "features/steps/#{singular_name}_steps.rb"
    end
  end

protected

  def banner
    "Usage: #{$0} cucumber"
  end

end
