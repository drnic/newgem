desc "Generate a #{$hoe.name}.gemspec file"
task :gemspec do
  File.open("#{$hoe.name}.gemspec", "w") do |file|
    file.puts $hoe.spec.to_ruby
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

desc 'Recreate Manifest.txt to include ALL files to be deployed'
task :manifest => :clean do
  require 'find'
  files = []
  $hoe.with_config do |config, _|
    exclusions = config["exclude"]
    abort "exclude entry missing from .hoerc. Aborting." if exclusions.nil?
    Find.find '.' do |path|
      next unless File.file? path
      next if path =~ exclusions
      files << path[2..-1]
    end
    files = files.sort.join "\n"
    File.open 'Manifest.txt', 'w' do |fp| fp.puts files end
  end
end