Feature: Post interesting project news to remote services (rubyflow, rubyforge, etc)
  In order to maximise impact of interest developments in a project
  As a RubyGem developer/promoter/maintainer
  I want to be able to post auto-generated and explicitly interesting news to remove services

  Scenario: Post auto-generated latest version news to rubyforge
    Given an existing newgem scaffold [called 'my_project']
    And I expect to post news to rubyforge
    When I embed and invoke task 'rake post_news'
    Then I post auto-generated news to rubyforge
  
  Scenario: Post latest News.rdoc to rubyflow
    Given an existing newgem scaffold [called 'my_project']
    And I expect to post news to rubyflow
    When I invoke task 'rake post_latest_news'
    Then I post latest news
  
