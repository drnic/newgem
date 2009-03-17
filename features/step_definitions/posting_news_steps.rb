Given /^I expect to post news to rubyforge$/ do
  RubyForge.any_instance.expects(:login)
  RubyForge.any_instance.expects(:post_news).with(project_name,
    "#{project_name} 0.0.1 Released", <<-EOS.gsub(/^    /, ''))
    #{project_name} version 0.0.1 has been released!
    
    FIX (describe your package)
    
    Changes:
    
    ## 0.0.1 #{Date.today}
    
    * 1 major enhancement:
      * Initial release
    EOS
end

Then /^I post auto\-generated news to rubyforge$/ do
  Then "output does match /Posted to rubyforge/"
end

Given /^I expect to post news to rubyflow$/ do
  Rubyflow.any_instance.expects(:login)
end