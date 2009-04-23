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

    Scenario: Using a File Picker dialog for root path
        Given I am at the Main Screen
        When I click the Choose... button for root path
        Then I should be shown a File Picker dialog

    Scenario: Using a File Picker dialog for choosing a output file
        Given I am at the Main Screen
        When I click the Choose... button for output file
        Then I should be shown a File Picker dialog