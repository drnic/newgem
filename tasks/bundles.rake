namespace :bundles do

  desc 'Install TextMate bundles for RubyGems'
  task :tm do
    require 'tmpdir'
    bundle = "RubyGem.tmbundle"
    bundle_dir = File.join(File.dirname(__FILE__), 'bundles/', bundle)
    `cp -R #{bundle_dir} #{Dir.tmpdir}`
    `open "#{File.join(Dir.tmpdir, bundle)}"`
  end
end

