desc 'Check that files included in generators match those in use by newgem itself'
task :generator_report do
  files = [
    %w( script/generate app_generators/newgem ),
    %w( script/destroy app_generators/newgem ),
    %w( tasks/deployment.rake app_generators/newgem ),
    %w( tasks/environment.rake app_generators/newgem ),
    %w( test/test_generator_helper.rb rubygems_generators/component_generator ),
    %w( tasks/website.rake newgem_generators/website ),
  ]
  # add "templates/#{source}" to each 2nd string
end

# def identical?(source, destination, &block)
#   return false if File.directory? destination
#   source      = block_given? ? File.open(source) {|sf| yield(sf)} : IO.read(source)
#   destination = IO.read(destination)
#   source == destination
# end
