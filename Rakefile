# gem 'hoe', '>= 2.1.1'
# require 'hoe'
require "./../hoe/lib/hoe"
%w[fileutils rubigen].each { |f| require f }
require './lib/newgem'

Hoe.plugin :newgem
Hoe.plugin :website
Hoe.plugin :cucumber_features

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'newgem' do
  self.developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  self.post_install_message = 'PostInstall.txt'
  self.extra_deps           = [
    ['activesupport','>= 2.0.2'],
    ['rubigen',">= #{RubiGen::VERSION}"],
    ['hoe', ">= #{Hoe::VERSION}"],
    ['RedCloth','= 4.1.1'], # for website generation
    ['syntax','>= 1.0.0']
  ]
  self.extra_dev_deps = [
    ['cucumber', ">= 0.1.8"]
  ]
end

require 'newgem/tasks'

remove_task :default
task :default => :features
