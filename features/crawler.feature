Feature: Crawler
  In order to look for new packages
  As a member of R community
  I want to be to have a up-to-date list of CRAN packages

  Scenario: A3 is present
    When I run "start foo.json"
    Then the output should contain "A3"
