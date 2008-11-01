Feature: Can deploy a website to a remote server via rsycn
  In order to promote and educate people about this project
  As a website maintainer
  I want a simple helper to generate and push a website to a remote server

  Scenario: Deploy project website via local rsync
    Given copy this project for test
    Given a safe folder for dummy deployment
    Given project website configuration for safe folder on local machine
    When task 'rake website' is invoked
    Then file 'website/index.html' is created
    Then remote file 'index.html' is created after local rsync
    Then remote folder 'rdoc' is created after local rsync
  
