Feature: Can run 'newgem' to create RubyGem scaffolds

  As a developer of RubyGems
  I want to create RubyGem scaffolds
  So that I can rapidly produce specs and code for encapsulated applications and libraries

  Scenario: Run newgem without any arguments
    Given a safe folder
    Given env variable $RUBYFORGE_USERNAME set to ''
    When newgem is executed for project 'my_project' with no options
    Then file 'Rakefile' is created
    And does invoke generator 'install_test_unit'
    And does invoke generator 'install_rubigen_scripts'
    And does not invoke generator 'install_website'
    And does not invoke generator 'install_rspec'
    And does not invoke generator 'install_shoulda'
    And does not invoke generator 'install_cucumber'
    And file 'config/website.yml' is not created
    And output same as contents of 'newgem.out'
    And Rakefile can display tasks successfully

  Scenario: Run newgem with project name containing hypens
    Given a safe folder
    Given env variable $RUBYFORGE_USERNAME set to ''
    When newgem is executed for project 'my-project' with no options
    Then Rakefile can display tasks successfully
  
  Scenario: Run newgem to include rspec
    Given a safe folder
    When newgem is executed for project 'my_rspec_project' with options '-T rspec'
    Then does invoke generator 'install_rspec'
    And does not invoke generator 'install_test_unit'
    And does not invoke generator 'install_shoulda'
    And does not invoke generator 'install_cucumber'
    And Rakefile can display tasks successfully

  Scenario: Run newgem to enable website
    Given a safe folder
    When newgem is executed for project 'my_project' with options '-w'
    Then does invoke generator 'install_website'
    And file 'config/website.yml.sample' is created
    And yaml file 'config/website.yml.sample' contains {"host" => "unknown@rubyforge.org", "remote_dir" => "/var/www/gforge-projects/my_project"}
    And Rakefile can display tasks successfully

  Scenario: Run newgem to enable website, with env $RUBYFORGE_USERNAME set
    Given a safe folder
    Given env variable $RUBYFORGE_USERNAME set to 'nicwilliams'
    When newgem is executed for project 'my_project' with options '-w'
    Then file 'config/website.yml.sample' is created
    And yaml file 'config/website.yml.sample' contains {"host" => "nicwilliams@rubyforge.org", "remote_dir" => "/var/www/gforge-projects/my_project"}
    And Rakefile can display tasks successfully

  Scenario: Run newgem to install misc generators on top of unit test framework
    Given a safe folder
    When newgem is executed for project 'my_project' with options '-i cucumber'
    Then does invoke generator 'install_test_unit'
    And does invoke generator 'install_cucumber'
    And does not invoke generator 'install_rspec'
    And Rakefile can display tasks successfully

  Scenario: Run newgem and show current version number
    Given a safe folder
    When newgem is executed only with options '--version'
    Then shows version number
  