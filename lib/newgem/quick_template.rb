require "erb"

module Newgem
  class QuickTemplate
    attr_reader :args, :text, :file
    def initialize(file)
      @file = file
      @text = File.read(file)
    end
    def exec(b)
      begin
        # b = binding
        template = ERB.new(@text, 0, "%<>")
        result = template.result(b)
        # Chomp the trailing newline
        result.gsub(/\n$/,'')
      rescue NameError
        puts "Error found for #{file}"
        raise $!
      end
    end
  end

  def erb(file, b)
     QuickTemplate.new(file).exec(b)
  end
end

