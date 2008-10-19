Feature: Can run create RubyGem scaffolds

  As a developer of RubyGems
  I want to create RubyGem scaffolds
  So that I can rapidly produce specs and code for encapsulated applications and libraries

  Scenario: Run newgem without any arguments
    Given a safe folder
    When newgem is executed for project 'my_project' with no options
    Then folder 'my_project' is created
    And file 'my_project/Rakefile' is created
    And output matches 'newgem.out'
    And invokes generator 'install_test_unit'
    And invokes generator 'install_website'
    And invokes generator 'install_rubigen_scripts'

  Scenario: Run newgem to include rspec
    Given a safe folder
    When newgem is executed for project 'my_rspec_project' with options '-T rspec'
    Then folder 'my_rspec_project' is created
    And invokes generator 'install_rspec'

  Scenario: Run newgem to disable website
    Given a safe folder
    When newgem is executed for project 'my_project' with options '-W'
    Then folder 'my_project' is created
    And does not invoke generator 'install_website'

