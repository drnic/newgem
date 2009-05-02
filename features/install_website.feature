Feature: RubyGems can have a website to promote and teach

  As a RubyGem developer
  I want rake tasks to help development and deployment of a website for the project
  So that I can spend time on the tests and code, and not excessive time on maintenance processes

  Scenario: Deploy project website via local rsync
    Given an existing newgem scaffold [called "my_project"]
    And project website configuration for safe folder on local machine
    When I invoke "install_website" generator with arguments ""
    And I invoke task "rake website"
    Then file "website/index.html" is created
    Then remote file "index.html" is created after local rsync
    Then remote folder "rdoc" is created after local rsync
