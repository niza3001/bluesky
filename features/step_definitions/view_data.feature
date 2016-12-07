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

  Scenario: User can select spesific course levels to view
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "1XX" from "Course Level"
    When User clicks on Go button on evaluation index page    
    Then User should see a table of 15 data rows
    
  Scenario: User can select udergrad course levels
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "Undergrad" from "Course Level"
    When User clicks on Go button on evaluation index page
    Then User should see a table of 15 data rows  

  Scenario: User can select year
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "2015" from "Year"
    When User clicks on Go button on evaluation index page
    Then User should see a table of 15 data rows 

  Scenario: User can select semester
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "C" from "Semester"
    When User clicks on Go button on evaluation index page
    Then User should see a table of 15 data rows 

  Scenario: User can select Instructor
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "Brent Walther" from "Instructor"
    When User clicks on Go button on evaluation index page
    Then User should see a table of 9 data rows 

  Scenario: User can select if see honor courses
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "Only" from "View Honor"
    When User clicks on Go button on evaluation index page
    Then User should see a table of 0 data rows 

  Scenario: User can reset all filters
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User selects "Brent Walther" from "Instructor"
    When User selects "C" from "Semester"
    When User clicks on Go button on evaluation index page
    When User clicks on Reset All Options button on evaluation index page
    Then User should see a table of 15 data rows

  Scenario: User can click on each semseter to see the only evaluations from that semester
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User clicks on term 2015C
    Then User should see a table of 15 data rows

  Scenario: User can click on each course number to see the only evaluations for that specific course
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User clicks on course number 111
    Then User should see a table of 9 data rows

  Scenario: User can view links for instructors, terms, course numbers, and edit
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    Then User should see a link for instructor Brent Walther
    And User should see a link for instructor John Smith
    And User should see a link for term 2015C
    And User should see a link for term 111
    And User should see the Edit link

  Scenario: User can see various bottums
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    Then User should see the Go button
    Then User should see the Group by Level button
    Then User should see the Import PICA Data button
    Then User should see the Import GPR Data button
    Then User should see the Missing Data button
    Then User should see the Export to Excel button

  Scenario: User can edit evaluation
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When User clicks on Edit link
    Then User should be redirected to evaluation edit page with Done button

  Scenario: User can see misssing data and be back to evaluation table page
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the evaluation index page
    When User clicks on Missing Data button on evaluation index page
    When User clicks on the Evaluation Data button
    Then User should see a table of 6 data rows

  Scenario: User can sing out
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the evaluation index page
    When User clicks on Home button on evaluation index page
    Then User should be on the home page

  Scenario: User can import from this page
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the evaluation index page
    When User clicks on Import PICA Data button on evaluation index page
    Then User should be on the import page





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
    When User vists the instructor index page
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
