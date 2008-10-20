Feature: RubyGems have features to be described and tested

  As a RubyGem developer
  I want to describe the project's features using Cucumber
  So that I can describe each feature of the project in readable text
  
  Scenario: Install Cucumber into a RubyGem
    Given an existing newgem scaffold [called 'my_project']
    When 'install_cucumber' generator is invoked with arguments ''
    Then folder 'my_project/features/steps' is created
  
