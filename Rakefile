require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'
require 'hoe'
include FileUtils
require File.join(File.dirname(__FILE__), 'lib', 'newgem', 'version')

AUTHOR = "Dr Nic Williams"
EMAIL = "drnicwilliams@gmail.com"
DESCRIPTION = "Make your own gems at home"
GEM_NAME = "newgem" # what ppl will type to install your gem
RUBYFORGE_PROJECT = "newgem"
HOMEPATH = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
DOWNLOAD_PATH = "http://rubyforge.org/projects/#{RUBYFORGE_PROJECT}"

REV = nil #File.read(".svn/entries")[/committed-rev="(\d+)"/, 1] rescue nil
VERS = Newgem::VERSION::STRING + (REV ? ".#{REV}" : "")
CLEAN.include ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store']
RDOC_OPTS = ['--quiet', '--title', "newgem documentation",
    "--opname", "index.html",
    "--line-numbers", 
    "--main", "README",
    "--inline-source"]

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
hoe = Hoe.new(GEM_NAME, VERS) do |p|
  p.author = AUTHOR 
  p.description = DESCRIPTION
  p.email = EMAIL
  p.summary = DESCRIPTION
  p.url = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs = ["test/**/test*.rb"]
  p.clean_globs = CLEAN  #An array of file patterns to delete on clean.

  # == Optional
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.extra_deps = [
    ['hoe', '>=1.2.0'],
    ['RedCloth','>=3.0.4'],
    ['syntax','>=1.0.0']
  ]
  #p.spec_extras    - A hash of extra values to set in the gemspec.
end

desc 'Generate website files'
task :website_generate => :load_consts do
  (Dir['website/**/*.txt'] - Dir['website/version*.txt']).each do |txt|
    sh %{ ruby scripts/txt2html #{txt} > #{txt.gsub(/txt$/,'html')} }
  end
  sh %{ ruby scripts/txt2js website/version.txt > website/version.js }
  sh %{ ruby scripts/txt2js website/version-raw.txt > website/version-raw.js }
end

desc 'Upload website files to rubyforge'
task :website_upload do
  config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
  host = "#{config["username"]}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{RUBYFORGE_PROJECT}/"
  local_dir = 'website'
  sh %{rsync -av #{local_dir}/ #{host}:#{remote_dir}}
end

desc 'Generate and upload website files'
task :website => [:website_generate, :website_upload]

task :load_consts do
  ENV['AUTHOR'] = AUTHOR
  ENV['EMAIL'] = EMAIL
  ENV['DESCRIPTION'] = DESCRIPTION
  ENV['GEM_NAME'] = GEM_NAME
  ENV['RUBYFORGE_PROJECT'] = RUBYFORGE_PROJECT
  ENV['HOMEPATH'] = HOMEPATH
  ENV['DOWNLOAD_PATH'] = DOWNLOAD_PATH
end

desc 'Release the website and new gem version'
task :deploy => [:check_version, :website, :release]

task :check_version do
  unless ENV['VERSION']
    puts 'Must pass a VERSION=x.y.z release version'
    exit
  end
  unless ENV['VERSION'] == VERS
    puts "Please update your version.rb to match the release version, currently #{VERS}"
    exit
  end
end
