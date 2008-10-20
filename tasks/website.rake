require 'yaml'

def website_config
  unless @website_config
    begin
      @website_config = YAML.load(File.read("config/website.yml"))
    rescue
      puts <<-EOS
To upload your website to a host, you need to configure
config/website.yml. See config/website.yml.sample for 
an example.
EOS
      exit
    end
  end
  @website_config
end

desc 'Generate website files'
task :website_generate => :ruby_env do
  (Dir['website/**/*.txt'] - Dir['website/version*.txt']).each do |txt|
    sh %{ #{RUBY_APP} script/txt2html #{txt} > #{txt.gsub(/txt$/,'html')} }
  end
end

desc 'Upload website files to rubyforge'
task :website_upload do
  local_dir  = 'website'
  host       = website_config["host"]
  host       = host ? "#{host}:" : ""
  remote_dir = website_config["remote_dir"]
  sh %{rsync -aCv #{local_dir}/ #{host}#{remote_dir}}
end

remove_task :publish_docs # recreate hoe's rubyforge specific version

desc 'Publish RDoc to RubyForge.'
task :publish_docs => [:clean, :docs] do
  local_dir  = 'doc'
  host       = website_config["host"]
  host       = host ? "#{host}:" : ""
  remote_dir = File.join(website_config["remote_dir"], "rdoc")
  sh %{rsync -aCv #{local_dir}/ #{host}#{remote_dir}}
end

desc 'Generate and upload website files'
task :website => [:website_generate, :website_upload, :publish_docs]
