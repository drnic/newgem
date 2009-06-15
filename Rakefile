# gem 'hoe', '>= 2.1.1'
# require 'hoe'
require "./../hoe/lib/hoe"
%w[fileutils rubigen].each { |f| require f }
require './lib/newgem'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'newgem' do
  self.developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  self.post_install_message = 'PostInstall.txt'
  self.extra_deps           = [
    ['activesupport','>= 2.0.2'],
    ['rubigen',">= #{RubiGen::VERSION}"],
    ['hoe', ">= #{Hoe::VERSION}"],
    ['RedCloth','>= 4.0.0'], # for website generation
    ['syntax','>= 1.0.0']
  ]
  self.extra_dev_deps = [
    ['cucumber', ">= 0.1.8"]
  ]
  self.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (self.rubyforge_name == self.name) ? self.rubyforge_name : "\#{self.rubyforge_name}/\#{self.name}"
  self.remote_rdoc_dir = File.join(path.gsub(/^#{self.rubyforge_name}\/?/,''), 'rdoc')
  self.rsync_args = '-av --delete --ignore-errors'
  self.readme_file = "README.rdoc"
  self.history_section_prefix = "=="
end

require 'newgem/tasks' # load /tasks/*.rake

remove_task :default
task :default => :features
