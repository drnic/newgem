desc 'Release the website and new gem version'
task :deploy => [:check_version, :website, :release] do
  puts <<-EOS.gsub(/^    /,'')
    ** Newgem deprecation warning: deploy task will be removed
       Instead:
        1. update version.rb with new version number
        2. run 'rake website' to push new version docco
        3. commit updated website files (containing new version number)
        4. run 'rake release VERSION=X.Y.Z' to push to rubyforge
  EOS
end

task :release do
  puts "Remember to tag your SCM. E.g."
  puts "  git tag REL-#{VERS}"
end

desc 'Runs tasks website_generate and install_gem as a local deployment of the gem'
task :local_deploy => [:website_generate, :install_gem]

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