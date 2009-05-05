Feature: Can run "newgem" to create RubyGem scaffolds

  As a developer of RubyGems
  I want to create RubyGem scaffolds
  So that I can rapidly produce specs and code for encapsulated applications and libraries

  Scenario: Run newgem without any arguments
    Given env variable $RUBYFORGE_USERNAME set to ""
    When newgem is executed for project "my_project" with no options
    Then file "Rakefile" is created
    And does invoke generator "install_test_unit"
    And does invoke generator "install_rubigen_scripts"
    And does not invoke generator "install_website"
    And does not invoke generator "install_rspec"
    And does not invoke generator "install_shoulda"
    And does not invoke generator "install_cucumber"
    And file "config/website.yml" is not created
    And I should see
      """
            create  
            create  doc
            create  lib
            create  script
            create  tasks
            create  lib/my_project
            create  History.txt
            create  Rakefile
            create  README.rdoc
            create  PostInstall.txt
            create  lib/my_project.rb
        dependency  install_test_unit
            create    test
            create    test/test_helper.rb
            create    test/test_my_project.rb
        dependency  install_rubigen_scripts
            exists    script
            create    script/generate
            create    script/destroy
            create  script/console
            create  Manifest.txt
            readme  readme
      Important
      =========

      * Open Rakefile
      * Update missing details (gem description, dependent gems, etc.)
      """
    And Rakefile can display tasks successfully
    When I invoke task "rake test"
    Then I should see all 1 tests pass

  Scenario: Run newgem with project name containing hypens
    Given env variable $RUBYFORGE_USERNAME set to ""
    When newgem is executed for project "my-project" with no options
    Then Rakefile can display tasks successfully
  
  Scenario: Run newgem to include rspec
    When newgem is executed for project "my_rspec_project" with options "-T rspec"
    Then does invoke generator "install_rspec"
    And does not invoke generator "install_test_unit"
    And does not invoke generator "install_shoulda"
    And does not invoke generator "install_cucumber"
    And Rakefile can display tasks successfully
    When I invoke task "rake spec"
    Then I should see all 1 examples pass

  Scenario: Run newgem to include shoulda
    When newgem is executed for project "my_shoulda_project" with options "-T shoulda"
    Then does invoke generator "install_shoulda"
    And does not invoke generator "install_test_unit"
    And does not invoke generator "install_rspec"
    And does not invoke generator "install_cucumber"
    And Rakefile can display tasks successfully
    When I invoke task "rake test"
    Then I should see all 1 tests pass

  Scenario: Run newgem to enable website
    When newgem is executed for project "my_project" with options "-w"
    Then does invoke generator "install_website"
    And file "config/website.yml.sample" is created
    And yaml file "config/website.yml.sample" contains {"host" => "unknown@rubyforge.org", "remote_dir" => "/var/www/gforge-projects/my_project"}
    And Rakefile can display tasks successfully

  Scenario: Run newgem to enable website, with env $RUBYFORGE_USERNAME set
    Given env variable $RUBYFORGE_USERNAME set to "nicwilliams"
    When newgem is executed for project "my_project" with options "-w"
    Then file "config/website.yml.sample" is created
    And yaml file "config/website.yml.sample" contains {"host" => "nicwilliams@rubyforge.org", "remote_dir" => "/var/www/gforge-projects/my_project"}
    And Rakefile can display tasks successfully

  Scenario: Run newgem to install misc generators on top of unit test framework
    When newgem is executed for project "my_project" with options "-i cucumber"
    Then does invoke generator "install_test_unit"
    And does invoke generator "install_cucumber"
    And does not invoke generator "install_rspec"
    And Rakefile can display tasks successfully

  Scenario: Run newgem to pull in defaults from ~/.newgem.yml file and no argument options
    And ~/.newgem.yml contains {"default" => "-T rspec -i cucumber"}
    When newgem is executed for project "my_project" with options ""
    Then does invoke generator "install_rspec"
    And does invoke generator "install_cucumber"
    And does not invoke generator "install_website"
    And does not invoke generator "install_test_unit"
    And Rakefile can display tasks successfully

  Scenario: Run newgem to pull in defaults from ~/.newgem.yml file and merge with runtime args
    And ~/.newgem.yml contains {"default" => "-T rspec -i cucumber"}
    When newgem is executed for project "my_project" with options "-i website"
    Then does invoke generator "install_rspec"
    And does invoke generator "install_cucumber"
    And does invoke generator "install_website"
    And does not invoke generator "install_test_unit"
    And Rakefile can display tasks successfully

  Scenario: Run newgem and show current version number
    When newgem is executed only with options "--version"
    Then shows version number
  