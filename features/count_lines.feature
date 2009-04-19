Feature: Counting lines of source code

    Scenario: Counting lines succesfully
        Given I have filled all the parameters correctly
        When I click the GO button
        Then I should have shown a line count
        And I should have a file report generated in CSV format
        And I should not have any error messages displaying

    Scenario: Invalid parameters
        Given I have not filled all the parameters correctly
        When I click the GO button
        Then I should have shown a error message
        And I should have nothing shown in the status area