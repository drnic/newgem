%w[rubygems rake rake/clean fileutils rubigen cucumber].each { |f| require f }
require File.dirname(__FILE__) + '/lib/newgem'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('newgem', Newgem::VERSION) do |p|
  p.developer('Dr Nic Williams', 'drnicwilliams@gmail.com')
  p.changes              = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.post_install_message = 'PostInstall.txt'
  p.extra_deps           = [
    ['activesupport','>= 2.0.2'],
    ['rubigen',">= #{RubiGen::VERSION}"],
    ['hoe', ">= #{Hoe::VERSION}"],
    ['RedCloth','>= 4.0.0'], # for website generation
    ['syntax','>= 1.0.0']
  ]
  p.extra_dev_deps = [
    ['cucumber', ">= #{::Cucumber::VERSION::STRING}"]
  ]
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake

namespace :hoe do
  desc "Applies patch files to the hoe.rb in latest hoe rubygem and stores in lib/hoe-patched.rb"
  task :patch do
    gem 'hoe'
    hoe_lib = $LOAD_PATH.grep(/hoe.*\/lib/)
    hoe_rb  = File.join(hoe_lib, 'hoe.rb')
    FileUtils.cp hoe_rb, File.dirname(__FILE__) + "/lib/hoe.rb"
    patches = Dir[File.dirname(__FILE__) + "/patches/hoe/*.patch"].sort
    patches.each do |patch|
      puts "Applying patch #{File.basename patch}"
      sh %{ cat #{patch} | patch -p1 }
    end
    patched_hoe = File.dirname(__FILE__) + "/lib/hoe-patched.rb"
    FileUtils.mv File.dirname(__FILE__) + "/lib/hoe.rb", patched_hoe

    help_msg = <<-EOS.gsub(/^\s+/,'')
    # Patched version of Hoe to allow any README.* file
    # Pending acceptance of ticket with this feature
    # File created by 'rake hoe:patch' in newgem
    # from patch files in patches/hoe/*.patch
    EOS

    contents = File.read(patched_hoe)
    File.open(patched_hoe, "w") do |f|
      f << help_msg + "\n"
      f << contents
    end
  end
end

task :default => :features
