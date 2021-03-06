Feature: Crawler
  In order to look for new packages
  As a member of R community
  I want to have an up-to-date list of CRAN packages

  Scenario: A3 is present
    When I run the command line tool
    Then the database should contain info about the package "A3"

  Scenario: A3 is indexed if checksum didn't change
    Given I run the command line tool
    When I run the command line tool
    Then The package "A3" should be indexed