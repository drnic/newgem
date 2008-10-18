Feature: Generate an executable/CLI scaffold

  As a RubyGem developer
  I want a scaffold for executable/CLI scripts
  So that I know the structure for constructing CLIs and can create them quickly

  Scenario: Run executable generator with name of executable
    Given an existing newgem scaffold [called 'my_project']
    When 'executable' generator is invoked with arguments 'my_app'
    Then folder 'my_project/bin/my_app' is created
    And file 'my_project/bin/my_app' is created
    And file 'my_project/lib/my_project/cli.rb' is created
    And file 'my_project/test/test_my_app_cli.rb' is created
  
