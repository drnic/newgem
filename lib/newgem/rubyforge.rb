require 'rubygems'
require 'rubyforge'

module Newgem
  class Rubyforge
    attr_reader :full_name, :email
    
    def initialize
      @full_name = rubyforge.userconfig['full_name'] || ENV['NAME']  || 'FIXME full name'
      @email     = rubyforge.userconfig['email']     || ENV['EMAIL'] || 'FIXME email'
    end
    
    def rubyforge
      @rubyforge ||= RubyForge.new(::RubyForge::CONFIG_F)
    end

  end
end