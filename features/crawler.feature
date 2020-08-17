Feature: Crawler
  In order to look for new packages
  As a member of R community
  I want to have an up-to-date list of CRAN packages

  Scenario: A3 is present
    When I run the command line tool
    Then the database contains these packages:
      | NAME                  | CHECKSUM |
      | Encounter at Farpoint | 1987 |
      | The Nth Degree        | 1991 |
      | All Good Things       | 1994 |
