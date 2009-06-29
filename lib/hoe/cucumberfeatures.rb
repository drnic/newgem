##
# Cucumber plugin for hoe.
#
# === Tasks Provided:
#
# features::  Run cucumber feature

module Hoe::Cucumberfeatures
  
  def define_cucumberfeatures_tasks
    begin
      gem 'cucumber'
      require 'cucumber/rake/task'

      Cucumber::Rake::Task.new(:features) do |t|
        t.cucumber_opts = "--format progress"
      end
    rescue LoadError => e
      p e
    end
  end
end
