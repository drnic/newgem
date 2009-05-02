module CliHelpers
  def newgem_cmd
    File.expand_path(File.dirname(__FILE__) + "/../../bin/newgem")
  end
end

World(CliHelpers)

