task :release do
  puts <<-EOS.gsub(/^  /,'')
  Remember to create tag your release; eg for Git:
    git tag REL-#{$hoe.version}
  
  Announce your release on RubyForge News:
    rake post_news
  EOS
end

desc 'Runs tasks website_generate and install_gem as a local deployment of the gem'
task :local_deploy => [:generator_report, :website_generate, :install_gem]

task :check_version do
  unless ENV['VERSION']
    puts 'Must pass a VERSION=x.y.z release version'
    exit
  end
  unless ENV['VERSION'] == $hoe.version
    puts "Please update your version.rb to match the release version, currently #{$hoe.version}"
    exit
  end
end

desc 'Install the package as a gem, without generating documentation(ri/rdoc)'
task :install_gem_no_doc => [:clean, :package] do
  sh "#{'sudo ' unless Hoe::WINDOZE }gem install pkg/*.gem --no-rdoc --no-ri"
end

namespace :manifest do
  desc 'Recreate Manifest.txt to include ALL files'
  task :refresh do
    `rake check_manifest | patch -p0 > Manifest.txt`
  end
end