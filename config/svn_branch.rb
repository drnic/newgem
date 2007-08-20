# Use svn_branch gem for branch/merge support
begin
  Gem.manage_gems
  gem = Gem.cache.search('svn_branch').sort_by { |g| g.version }.last
  if gem.nil?
    puts <<-EOS
You can install RubyGem 'svn_branch' to get helper tasks for svn branch management
    gem install svn_branch
EOS
  else
    path = gem.full_gem_path
    Dir[File.join(path, "/**/tasks/**/*.rake")].sort.each { |ext| load ext }
  end
rescue LoadError
end
