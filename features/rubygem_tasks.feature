Feature: Generated RubyGems have various rake tasks to aide their development
  In order to maintain and release generated RubyGems
  As a RubyGem developer
  I want rake tasks to perform routine maintenance and deployment tasks

  Scenario: Generate RubyGem
    Given an existing newgem scaffold [called 'my_project']
    And 'pkg' folder is deleted
    When task 'rake gem' is invoked
    Then folder 'pkg' is created
    And file matching 'pkg/my_project-0.0.1.gem' is created
    And gem spec key 'rdoc_options' contains '--mainREADME.rdoc'
    And gem spec key 'dependencies' contains /newgem \(>= [\d.]+, development\)/
