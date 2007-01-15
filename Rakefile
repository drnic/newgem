require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'
include FileUtils
require File.join(File.dirname(__FILE__), 'lib', 'newgem', 'version')

AUTHOR = "Dr Nic Williams"
EMAIL = "drnicwilliams@gmail.com"
DESCRIPTION = "Make your own gems at home"
RUBYFORGE_PROJECT = "newgem"
HOMEPATH = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
BIN_FILES = %w( newgem )
RELEASE_TYPES = %w( gem ) # can use: gem, tar, zip

NAME = "newgem"
REV = nil #File.read(".svn/entries")[/committed-rev="(\d+)"/, 1] rescue nil
VERS = ENV['VERSION'] || (Newgem::VERSION::STRING + (REV ? ".#{REV}" : ""))
CLEAN.include ['**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = ['--quiet', '--title', "newgem documentation",
    "--opname", "index.html",
    "--line-numbers", 
    "--main", "README",
    "--inline-source"]

desc "Packages up newgem gem to make gems."
task :default => [:test]
task :package => [:clean]

task :test do
  require File.dirname(__FILE__) + '/test/all_tests.rb'
end

spec =
    Gem::Specification.new do |s|
        s.name = NAME
        s.version = VERS
        s.platform = Gem::Platform::RUBY
        s.has_rdoc = true
        s.extra_rdoc_files = ["README", "CHANGELOG"]
        s.rdoc_options += RDOC_OPTS + ['--exclude', '^(examples|extras)\/']
        s.summary = DESCRIPTION
        s.description = DESCRIPTION
        s.author = AUTHOR
        s.email = EMAIL
        s.homepage = HOMEPATH
        s.executables = BIN_FILES
        s.rubyforge_project = RUBYFORGE_PROJECT
        s.bindir = "bin"

        s.add_dependency('activesupport', '>=1.3.1')
        s.add_dependency('hoe', '>=1.1.6')

        s.files = %w(README Rakefile) +
          Dir.glob("{bin,doc,test,lib,templates,extras,website,script}/**/*") + 
          Dir.glob("ext/**/*.{h,c,rb}") +
          Dir.glob("examples/**/*.rb") +
          Dir.glob("tools/*.rb")
        
        s.require_path = "lib"
        # s.extensions = FileList["ext/**/extconf.rb"].to_a
    end

Rake::GemPackageTask.new(spec) do |p|
    p.need_tar = RELEASE_TYPES.include? 'tar'
    p.need_zip = RELEASE_TYPES.include? 'zip'
    p.gem_spec = spec
end

task :install => [ :package ] do
  sh %{sudo gem install pkg/#{NAME}-#{VERS}}
end

task :install_win => [:package] do
   puts   "gem install pkg/#{NAME}-#{VERS}.gem"
   puts system("gem install pkg/#{NAME}-#{VERS}.gem")
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  system('rubyforge login')
  for ext in RELEASE_TYPES
    release_command = "rubyforge add_release #{RUBYFORGE_PROJECT} #{NAME} 'REL #{VERS}' pkg/#{NAME}-#{VERS}.#{ext}"
    puts release_command
    system(release_command)
  end
end

