Story: Sell RubyFools
  As a conference organiser
  I want to sell RubyFools
  So that I can make the world a better place
  
  Scenario: Sell a cpuple
    Given there are 5 rubyfools
    When I sell 2 rubyfools
    Then there should be 3 rubyfools
