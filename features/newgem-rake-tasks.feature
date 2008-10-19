Feature: RubyGems have support rake tasks

  As a RubyGem developer
  I want rake tasks to help development and deployment
  So that I can spend time on the tests and code, and not excessive time on maintenance processes

  Scenario: Deploy project website via rsync
    Given an existing newgem scaffold [called 'my_project']
    Given project website configuration for safe folder on local machine
    When rake task 'website' is invoked
    Then file 'my_project/website/index.html' is created
    Then file 'website/index.html' is created after local rsync
  
