Feature: Can run create RubyGem scaffolds

  As a developer of RubyGems
  I want to create RubyGem scaffolds
  So that I can rapidly produce specs and code for encapsulated applications and libraries

  Scenario: Run newgem without any arguments
    Given a safe folder
    When newgem is executed for project 'my_project'
    Then folder 'my_project' is created
    Then file 'my_project/Rakefile' is created
  
