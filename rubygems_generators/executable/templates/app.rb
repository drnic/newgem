#!/usr/bin/env ruby
#
#  Created <%= "by #{author} " if author %>on <%= (now = Time.now).year %>-<%= now.month %>-<%= now.day %>.
#  Copyright (c) <%= now.year %>. All rights reserved.

begin
  require 'rubygems'
rescue LoadError
  # no rubygems to load, so we fail silently
end

require 'optparse'

# NOTE: the option -p/--path= is given as an example, and should probably be replaced in your application.

OPTIONS = {
  :path     => '~'
}
MANDATORY_OPTIONS = %w(  )

parser = OptionParser.new do |opts|
  opts.banner = <<BANNER
This application is wonderful because...

Usage: #{File.basename($0)} [options]

Options are:
BANNER
  opts.separator ""
  opts.on("-p", "--path=PATH", String,
          "The root path for selecting files",
          "Default: ~") { |OPTIONS[:path]| }
  opts.on("-h", "--help",
          "Show this help message.") { puts opts; exit }
  opts.parse!(ARGV)

  if MANDATORY_OPTIONS && MANDATORY_OPTIONS.find { |option| OPTIONS[option.to_sym].nil? }
    puts opts; exit
  end
end

path = OPTIONS[:path]

# do stuff