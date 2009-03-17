begin
  require 'rubyforge'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rubyforge'
  require 'rubyforge'
end

module Newgem
  class Rubyforge
    attr_reader :full_name, :email, :github_username

    def initialize
      @full_name = rubyforge.userconfig['full_name'] || ENV['NAME']  || 'FIXME full name'
      @email     = rubyforge.userconfig['email']     || ENV['EMAIL'] || 'FIXME email'
      @github_username =
        rubyforge.userconfig['github_username'] || ENV['GITHUB_USERNAME'] || 'GITHUB_USERNAME'
    end

    def rubyforge
      @rubyforge ||= RubyForge.new(::RubyForge::CONFIG_F).configure
    end

  end
end