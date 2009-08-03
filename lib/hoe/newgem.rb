##
# Gemspec plugin for hoe.
#
# === Tasks Provided:
#
# gemspec::  Generate the gemspec file
# release

Hoe.plugin :manifest

module Hoe::Newgem
  def initialize_newgem
    require(File.dirname(__FILE__) + "/../newgem")
    require 'newgem/tasks'

    self.clean_globs |= %w[**/.DS_Store tmp *.log]
    path = (self.rubyforge_name == self.name) ? self.rubyforge_name : "\#{self.rubyforge_name}/\#{self.name}"
    self.remote_rdoc_dir = File.join(path.gsub(/^#{self.rubyforge_name}\/?/,''), 'rdoc')
    self.rsync_args = '-av --delete --ignore-errors'
    self.readme_file = "README.rdoc"
  end
  
  # Define +gemspec+ task if not already defined
  def define_newgem_tasks
    unless self.extra_dev_deps.find { |dep| dep.first == 'newgem' }
      require File.dirname(__FILE__) + '/../newgem'
      self.extra_dev_deps ||= []
      self.extra_dev_deps << ['newgem', ">= #{::Newgem::VERSION}"] unless name == 'newgem'
    end
    
    return if Rake::Task.tasks.find { |t| t.name == 'gemspec' }
    desc "Generate a #{name}.gemspec file"
    task :gemspec do
      File.open("#{name}.gemspec", "w") do |file|
        file.puts spec.to_ruby
      end
    end
    
    task :release do
      puts <<-EOS.gsub(/^  /,'')
      Remember to create tag your release; eg for Git:
        git tag REL-#{$hoe.version}

      Announce your release on RubyForge News:
        rake post_news
      EOS
    end

    task :check_version do
      unless ENV['VERSION']
        puts 'Must pass a VERSION=x.y.z release version'
        exit
      end
      unless ENV['VERSION'] == $hoe.version
        puts "Please update your lib/#{$hoe.name}.rb to match the release version, currently #{$hoe.version}"
        exit
      end
    end

    desc 'Install the package as a gem, without generating documentation(ri/rdoc)'
    task :install_gem_no_doc => [:clean, :package] do
      sh "#{'sudo ' unless Hoe::WINDOZE }gem install pkg/*.gem --no-rdoc --no-ri"
    end
    
    task :ruby_env do
      $ruby_app = if RUBY_PLATFORM =~ /java/
        "jruby"
      else
        "ruby"
      end
    end
    
  end
end
