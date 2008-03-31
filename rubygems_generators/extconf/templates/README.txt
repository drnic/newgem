Important:
  You may want to add the following pattern matches to your
  SCM ignore list (e.g. .gitignore file):
  
    Makefile
    *.o
    *.bundle
    *.so
    *.dll
    pkg
    doc
    .DS_Store
  
  Also, in your ~/.hoerc file ADD the following exclusions:
    exclude: !ruby/regexp /tmp$|CVS|\.svn|_darcs|\.git|local/.*\.rb$|Makefile|.*\.o$|.*\.bundle$|.*\.so$|.*\.dll$/