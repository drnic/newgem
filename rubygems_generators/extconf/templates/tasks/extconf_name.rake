namespace :extconf do
  extension = File.basename(__FILE__, '.rake')

  ext = "ext/#{extension}"
  ext_so = "#{ext}/#{extension}.#{Config::CONFIG['DLEXT']}"
  ext_files = FileList[
    "#{ext}/*.c",
    "#{ext}/*.h",
    "#{ext}/*.rl",
    "#{ext}/extconf.rb",
    "#{ext}/Makefile",
    # "lib"
  ]


  task :compile => extension do
    if Dir.glob("**/#{extension}.*").length == 0
      STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      STDERR.puts "Gem actually failed to build.  Your system is"
      STDERR.puts "NOT configured properly to build #{GEM_NAME}."
      STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      exit(1)
    end
  end

  desc "Builds just the #{extension} extension"
  task extension.to_sym => ["#{ext}/Makefile", ext_so ]

  file "#{ext}/Makefile" => ["#{ext}/extconf.rb"] do
    Dir.chdir(ext) do ruby "extconf.rb" end
  end

  file ext_so => ext_files do
    Dir.chdir(ext) do
      sh(PLATFORM =~ /win32/ ? 'nmake' : 'make')
    end
  end
end