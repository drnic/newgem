Feature: RubyGems have features to be described and tested

  As a RubyGem developer
  I want to describe the project's features using Cucumber
  So that I can describe each feature of the project in readable text
  
  Scenario: Install Cucumber into a RubyGem
    Given an existing newgem scaffold [called 'my_project']
    When 'install_cucumber' generator is invoked with arguments ''
    Then folder 'features/step_definitions' is created
    Then folder 'features/support' is created
    And file 'features/development.feature' is created
    And file 'features/support/env.rb' is created
    And file 'features/step_definitions/common_steps.rb' is created
    And file 'tasks/cucumber.rake' is not created as it is loaded via newgem itself

  Scenario: NewGem and generated gems should share some common files
    Given an existing newgem scaffold [called 'my_project']
    When 'install_cucumber' generator is invoked with arguments ''
    Then gem file 'features/step_definitions/common_steps.rb' and generated file 'features/step_definitions/common_steps.rb' should be the same
    Then gem file 'features/development.feature' and generated file 'features/development.feature' should be the same

  Scenario: Installed Cucumber includes a 'rake features' task
    Given an existing newgem scaffold [called 'my_project']
    And 'install_cucumber' generator is invoked with arguments ''
    When task 'rake features' is invoked
    Then task 'rake features' is executed successfully
    And output does match /\.{6}/

