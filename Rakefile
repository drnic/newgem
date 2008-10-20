%w[rubygems rake rake/clean fileutils hoe].each { |f| require f }
require File.dirname(__FILE__) + '/lib/newgem'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('newgem', Newgem::VERSION) do |p|
  p.developer('Dr Nic Williams', 'drnicwilliams@gmail.com')
  p.changes              = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.post_install_message = 'PostInstall.txt'
  p.extra_deps           = [
    ['RedCloth','>=4.0.0'],
    ['syntax','>=1.0.0'],
    ['activesupport','>=2.0.2'],
    ['rubigen','>=1.3.3'],
    ['hoe', '>=1.8.0']
  ]
  p.spec_extras['rdoc_options'] = ['--main', Dir['README*'].first] # hopefully fixed in future hoe > 1.8
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake

