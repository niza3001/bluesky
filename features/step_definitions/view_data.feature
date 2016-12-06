Feature: Be able to view data in the database

  Scenario: User can sort table of data based on semester
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the evaluation index page
    When Clicks on header of Term
    Then User should see a table of 7 data rows
    And User should see a link for instructor Brent Walther

  Scenario: User can sort table of data based on Course
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When Clicks on header of Course
    Then User should see a table of 14 data rows

  Scenario: User can sort table of data based on level
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When Clicks on header of Group by Level
    Then User should see a table of 12 data rows

  Scenario: User can select specific course levels to view
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "2XX" from "course_level_filter"
    When User clicks on button "Go"
    Then User should see a table of 0 data rows


    Scenario: User can select specific course to view
      Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
      And There exists 1 group of 5 evaluation records in the database for instructor John Smith
      And User is authenticated
      When User visits the evaluation index page
      When User selects "111" from "course_name"
      When User clicks on button "Go"
      Then User should see a table of 9 data rows


    Scenario: User can select specific instructor to view
      Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
      And There exists 1 group of 5 evaluation records in the database for instructor John Smith
      And User is authenticated
      When User visits the evaluation index page
      When User selects "Brent Walther" from "instructor_name"
      When User clicks on button "Go"
      Then User should see a table of 9 data rows


    Scenario: User can select specific year and semester to view
      Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
      And There exists 1 group of 5 evaluation records in the database for instructor John Smith
      And User is authenticated
      When User visits the evaluation index page
      When User selects "2015" from "year"
      When User selects "C" from "semester"
      When User clicks on button "Go"
      Then User should see a table of 15 data rows


  Scenario: User can select udergrad course levels
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "Undergrad" from "course_level_filter"
    When User clicks on button "Go"
    Then User should see a table of 15 data rows

  #-----------

  Scenario: User can view a formatted table of data
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the evaluation index page
    Then User should see a table of 6 data rows

  Scenario: User can view all instructors
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the instructor index page
    Then User should see a link for instructor Brent Walther
    And User should see a link for instructor John Smith

  Scenario: User can view an instructors courses
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the evaluation index page
    And Clicks on the name of instructor Brent Walther
    Then User should see courses page for Brent Walther

  Scenario: User can view an empty row between groups and check weighted means are stored in the correct columns
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the evaluation index page
    Then User should see a table of 9 data rows

  Scenario: Administrator is able to access the manual evaluation entry screen
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    And There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    When User visits the evaluation index page
    Then User should see a table of 6 data rows

  Scenario: Read/Write is able to access the manual evaluation entry screen
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class readWrite
    And There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    When User visits the evaluation index page
    Then User should see a table of 6 data rows

  Scenario: Read Only is able to access the manual evaluation entry screen
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class readOnly
    And There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    When User visits the evaluation index page
    Then User should see a table of 6 data rows
