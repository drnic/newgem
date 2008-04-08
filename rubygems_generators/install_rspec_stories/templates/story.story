Story: Sell <%= gem_name %>
  As a <%= gem_name %> artist
  I want to sell <%= gem_name %>
  So that I can make the world a better place
  
  Scenario: Sell a couple
    Given there are 5 <%= gem_name %>
    When I sell 2 <%= gem_name %>
    Then there should be 3 <%= gem_name %> left
