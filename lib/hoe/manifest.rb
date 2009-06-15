##
# Manifest plugin for hoe.
#
# === Tasks Provided:
#
# manifest::  Recreate the Manifest.txt

module Hoe::Manifest
  Hoe.plugin :manifest # activate globally, fine for general purpose tasks

  ##
  # Initialize plugin and do mysterious things to Hoe object
  def initialize_manifest
  end

  ##
  # Define tasks for plugin.
  def define_manifest_tasks
    desc 'Recreate Manifest.txt to include ALL files to be deployed'
    task :manifest => :clean do
      require 'find'
      files = []
      with_config do |config, _|
        exclusions = config["exclude"]
        abort "exclude entry missing from .hoerc. Aborting." if exclusions.nil?
        Find.find '.' do |path|
          next unless File.file? path
          next if path =~ exclusions
          files << path[2..-1]
        end
        files = files.sort.join "\n"
        File.open 'Manifest.txt', 'w' do |fp| fp.puts files end
      end
    end
  end
end
