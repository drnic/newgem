require 'rbconfig'

# This generator bootstraps a Rails project for use with Cucumber
class InstallCucumberGenerator < RubiGen::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  attr_reader :project_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    @project_name = File.basename(File.expand_path(destination_root))
  end

  def manifest
    record do |m|
      script_options     = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }

      m.directory 'features/step_definitions'
      m.directory 'features/support'
      m.file      'features/development.feature', 'features/development.feature'
      m.file      'features/step_definitions/common_steps.rb', 'features/step_definitions/common_steps.rb'
      m.template  'features/support/env.rb.erb', 'features/support/env.rb'
      m.file      'features/support/common.rb', 'features/support/common.rb'
    end
  end

protected

  def banner
    "Usage: #{$0} cucumber"
  end

end