Feature: Write and test C-extensions
  In order to leverage existing C libraries
  As a RubyGems developer
  I want to generate a scaffold with test/spec support for writing Ruby C-extensions

  Scenario: Run extconf generator with name of extension
    Given an existing newgem scaffold [called 'my_project']
    When 'extconf' generator is invoked with arguments 'my_ext'
    Then folder 'ext/my_ext' is created
    And file 'ext/my_ext/extconf.rb' is created
    And file 'ext/my_ext/my_ext.c' is created
    And file 'test/test_my_ext_extn.rb' is created
    And file '.autotest' is created

  Scenario: Run extconf generator with name of extension on rspec project
  Given an existing newgem scaffold using options '-T rspec' [called 'my_project']
    When 'extconf' generator is invoked with arguments 'my_ext'
    Then folder 'ext/my_ext' is created
    And file 'ext/my_ext/extconf.rb' is created
    And file 'ext/my_ext/my_ext.c' is created
    And file 'spec/my_ext_extn_spec.rb' is created
    And file '.autotest' is created
