Feature: Development processes of newgem itself (rake tasks)

  As a Newgem maintainer or contributor
  I want rake tasks to maintain and release the gem
  So that I can spend time on the tests and code, and not excessive time on maintenance processes
  
  # Scenario: Deploy project website via local rsync
  #   Given copy this project for test
  #   Given a safe folder for dummy deployment
  #   Given project website configuration for safe folder on local machine
  #   When task 'rake website' is invoked
  #   Then file 'website/index.html' is created
  #   Then remote file 'index.html' is created after local rsync
  #   Then remote folder 'doc' is created after local rsync
  # 
  Scenario: Generate RubyGem
    Given this project is active project folder
    Given 'package' folder is deleted
    When task 'rake gem' is invoked
    Then folder 'pkg' is created
    And file matching 'pkg/newgem-*.gem' is created
    And gem spec key 'rdoc_options' contains 'README.rdoc'
