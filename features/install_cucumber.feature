Feature: RubyGems have features to be described and tested

  As a RubyGem developer
  I want to describe the project's features using Cucumber
  So that I can describe each feature of the project in readable text
  
  Scenario: Install Cucumber into a RubyGem
    Given an existing newgem scaffold [called 'my_project']
    When 'install_cucumber' generator is invoked with arguments ''
    Then folder 'features/steps' is created
    And file 'features/development.feature' is created
    And file 'features/steps/common.rb' is created
    And file 'tasks/cucumber.rake' is not created as it is loaded via newgem itself

  Scenario: Installed Cucumber includes a 'rake features' task
    Given an existing newgem scaffold [called 'my_project']
    And 'install_cucumber' generator is invoked with arguments ''
    When task 'rake features' is invoked
    Then task 'rake features' is executed successfully
    And output does match /Feature: Development processes of newgem itself \(rake tasks\)/
    And output does match /And file matching 'pkg/\*\.gem' is created/
    And output does not match /You can use these snippets to implement pending steps/
