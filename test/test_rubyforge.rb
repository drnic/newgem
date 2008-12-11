require File.join(File.dirname(__FILE__), "test_helper.rb")
require 'newgem/rubyforge-ext'

class TestRubyforge < Test::Unit::TestCase
  
  def set_rubyforge_home(dir)
    RubyForge.send(:remove_const, :HOME)     if RubyForge.const_defined?(:HOME)
    RubyForge.send(:remove_const, :CONFIG_D) if RubyForge.const_defined?(:CONFIG_D)
    RubyForge.send(:remove_const, :CONFIG_F) if RubyForge.const_defined?(:CONFIG_F)
    
    RubyForge.const_set(:HOME, dir)
    RubyForge.const_set(:CONFIG_D, File.join(dir, '.rubyforge'))
    RubyForge.const_set(:CONFIG_F, File.join(dir, '.rubyforge', 'user-config.yml'))
  end
  
  def test_full_name_should_be_placeholder_if_nothing_found
    set_rubyforge_home('/tmp')
    ENV.delete('NAME')
    assert_equal 'FIXME full name', Newgem::Rubyforge.new.full_name
  end
  
  def test_email_should_be_placeholder_if_nothing_found
    set_rubyforge_home('/tmp')
    ENV.delete('EMAIL')
    assert_equal 'FIXME email', Newgem::Rubyforge.new.email
  end
  
  def test_github_username_should_be_placeholder_if_nothing_found
    set_rubyforge_home('/tmp')
    ENV.delete('GITHUB_USERNAME')
    assert_equal 'GITHUB_USERNAME', Newgem::Rubyforge.new.github_username
  end
  
  def test_full_name_should_come_from_environment
    set_rubyforge_home('/tmp')
    ENV['NAME'] = 'Environment Fullname'
    assert_equal 'Environment Fullname', Newgem::Rubyforge.new.full_name
  end
  
  def test_email_should_come_from_environment
    set_rubyforge_home('/tmp')
    ENV['EMAIL'] = 'env@email.com'
    assert_equal 'env@email.com', Newgem::Rubyforge.new.email
  end
  
  def test_github_username_should_come_from_environment
    set_rubyforge_home('/tmp')
    ENV['GITHUB_USERNAME'] = 'ghuser'
    assert_equal 'ghuser', Newgem::Rubyforge.new.github_username
  end
  
  def test_full_name_should_come_from_user_config
    set_rubyforge_home File.join(File.dirname(__FILE__), 'fixtures', 'home')
    assert_equal 'Fullname McDeveloper', Newgem::Rubyforge.new.full_name
  end
  
  def test_email_should_come_from_user_config
    set_rubyforge_home File.join(File.dirname(__FILE__), 'fixtures', 'home')
    assert_equal 'firstlast@newgem.tld', Newgem::Rubyforge.new.email
  end
  
  def test_github_username_should_come_from_user_config
    set_rubyforge_home File.join(File.dirname(__FILE__), 'fixtures', 'home')
    assert_equal 'githubbahubba', Newgem::Rubyforge.new.github_username
  end
end
