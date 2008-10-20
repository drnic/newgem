require 'hoe'
require 'newgem/version'
require 'newgem/support/tasks'

AUTHOR            = "Dr Nic Williams"
EMAIL             = "drnicwilliams@gmail.com"
DESCRIPTION       = "Make your own gems at home"
GEM_NAME          = "newgem" # what ppl will type to install your gem
RUBYFORGE_PROJECT = "newgem"
HOMEPATH          = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
DOWNLOAD_PATH     = "http://rubyforge.org/projects/#{RUBYFORGE_PROJECT}"

@config_file = "~/.rubyforge/user-config.yml"
@config = nil
RUBYFORGE_USERNAME = ENV['RUBYFORGE_USERNAME']
def rubyforge_username
  unless @config
    begin
      @config = YAML.load(File.read(File.expand_path(@config_file)))
    rescue
      puts <<-EOS
ERROR: No rubyforge config file found: #{@config_file}
Run 'rubyforge setup' to prepare your env for access to Rubyforge
 - See http://newgem.rubyforge.org/rubyforge.html for more details
      EOS
      exit
    end
  end
  RUBYFORGE_USERNAME.replace(@config["username"] || "unknown")
end

CLEAN.include ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store', 'tmp', '*.log']

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
hoe = Hoe.new(GEM_NAME, VERS = Newgem::VERSION::STRING) do |p|
  p.developer(AUTHOR, EMAIL)
  p.description    = DESCRIPTION
  p.summary        = DESCRIPTION
  p.url            = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs     = ["test/**/test*.rb"]
  p.post_install_message = 'PostInstall.txt'
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.extra_deps = [
    ['RedCloth','>=4.0.0'],
    ['syntax','>=1.0.0'],
    ['activesupport','>=2.0.2'],
    ['rubigen','>=1.3.0'],
    ['hoe', '>=1.8.0']
  ]
end

CHANGES = hoe.paragraphs_of('History.txt', 0..1).join("\n\n")
PATH    = (RUBYFORGE_PROJECT == GEM_NAME) ? RUBYFORGE_PROJECT : "\#{RUBYFORGE_PROJECT}/\#{GEM_NAME}"
hoe.remote_rdoc_dir = File.join(PATH.gsub(/^#{RUBYFORGE_PROJECT}\/?/,''), 'rdoc')
hoe.rsync_args = '-av --delete --ignore-errors'
