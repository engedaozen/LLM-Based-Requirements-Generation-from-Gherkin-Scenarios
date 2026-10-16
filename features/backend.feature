@backend
Feature: Backend Module Full AI Analysis (UC-B2 → UC-B6)
################################################################################
# UC-B1 – Staff Authentication and Session Management
################################################################################

@uc_b1 @requirement
Scenario: UC-B1 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Staff Authentication and Session Management (UC-B1)
      As an Operational Staff member (Cashier, Manager, Admin)
      I want to log in securely
      So that I can access the system functions according to my role

      # Basic Flow: Successful Login
      Scenario Outline: Successful login generates secure token
        Given the user is on the login screen
        When the user enters valid username "<username>" and password "<password>"
        And clicks the "Login" button
        Then the system should verify credentials against the database
        And the system should authorize the user with role "<role>"
        And the system should generate a valid "Session Token" (JWT)
        And redirect the user to the "<dashboard_type>"

        Examples:
          | username | password | role    | dashboard_type  |
          | user_csh | pass123  | Cashier | Cashier Panel   |
          | user_adm | pass123  | Admin   | Admin Dashboard |

      # Exception Flow I1: Brute-Force Protection
      Scenario: Account lockout after repeated failed attempts
        Given the user has failed to log in "4" times in the last "5 minutes"
        When the user enters an invalid password for the 5th time
        Then the system should lock the account automatically
        And display a "Account locked for security reasons" message
        And log this security event

      # Exception Flow I3: Deactivated User
      Scenario: Login attempt by a deactivated user
        Given the user credentials are correct
        But the user account status is set to "Passive" by Admin
        When the user attempts to log in
        Then the system should deny access
        And display a "Account is deactivated" warning
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-B1.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_b1 @testcase
Scenario: UC-B1 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Staff Authentication and Session Management (UC-B1)
      As an Operational Staff member (Cashier, Manager, Admin)
      I want to log in securely
      So that I can access the system functions according to my role

      # Basic Flow: Successful Login
      Scenario Outline: Successful login generates secure token
        Given the user is on the login screen
        When the user enters valid username "<username>" and password "<password>"
        And clicks the "Login" button
        Then the system should verify credentials against the database
        And the system should authorize the user with role "<role>"
        And the system should generate a valid "Session Token" (JWT)
        And redirect the user to the "<dashboard_type>"

        Examples:
          | username | password | role    | dashboard_type  |
          | user_csh | pass123  | Cashier | Cashier Panel   |
          | user_adm | pass123  | Admin   | Admin Dashboard |

      # Exception Flow I1: Brute-Force Protection
      Scenario: Account lockout after repeated failed attempts
        Given the user has failed to log in "4" times in the last "5 minutes"
        When the user enters an invalid password for the 5th time
        Then the system should lock the account automatically
        And display a "Account locked for security reasons" message
        And log this security event

      # Exception Flow I3: Deactivated User
      Scenario: Login attempt by a deactivated user
        Given the user credentials are correct
        But the user account status is set to "Passive" by Admin
        When the user attempts to log in
        Then the system should deny access
        And display a "Account is deactivated" warning
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-B1.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_b1 @uml
Scenario: UC-B1 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Staff Authentication and Session Management (UC-B1)
      As an Operational Staff member (Cashier, Manager, Admin)
      I want to log in securely
      So that I can access the system functions according to my role

      # Basic Flow: Successful Login
      Scenario Outline: Successful login generates secure token
        Given the user is on the login screen
        When the user enters valid username "<username>" and password "<password>"
        And clicks the "Login" button
        Then the system should verify credentials against the database
        And the system should authorize the user with role "<role>"
        And the system should generate a valid "Session Token" (JWT)
        And redirect the user to the "<dashboard_type>"

        Examples:
          | username | password | role    | dashboard_type  |
          | user_csh | pass123  | Cashier | Cashier Panel   |
          | user_adm | pass123  | Admin   | Admin Dashboard |

      # Exception Flow I1: Brute-Force Protection
      Scenario: Account lockout after repeated failed attempts
        Given the user has failed to log in "4" times in the last "5 minutes"
        When the user enters an invalid password for the 5th time
        Then the system should lock the account automatically
        And display a "Account locked for security reasons" message
        And log this security event

      # Exception Flow I3: Deactivated User
      Scenario: Login attempt by a deactivated user
        Given the user credentials are correct
        But the user account status is set to "Passive" by Admin
        When the user attempts to log in
        Then the system should deny access
        And display a "Account is deactivated" warning
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-B1_Sequence.txt"
  And The file should contain valid PlantUML code

################################################################################
# UC-B2 – System Configuration Management
################################################################################

@uc_b2 @requirement
Scenario: UC-B2 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: System Configuration Management (UC-B2)
      As an Admin
      I want to update operational settings (pricing, capacity)
      So that the system adapts to changing business needs

      Background:
        Given the Admin is logged in and authorized for the Configuration Menu

      # Basic Flow: Successful Update
      Scenario Outline: Admin updates configuration settings
        When the Admin changes the "<setting>" to "<new_value>"
        And saves the changes
        Then the system should validate the new value against business rules
        And update the database while maintaining data integrity
        And distribute the new config to relevant components
        And display a "Settings updated successfully" message

        Examples:
          | setting       | new_value |
          | Game Price    | 15.00     |
          | Zone Capacity | 100       |

      # Exception Flow I2: Data Integrity / Business Rule Violation
      Scenario: Attempt to save invalid configuration
        When the Admin attempts to set "Zone Capacity" to "-5"
        Then the system should reject the update
        And display an "Invalid numeric value" or "Business rule violation" error
        And the database should remain unchanged
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-B2.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_b2 @testcase
Scenario: UC-B2 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: System Configuration Management (UC-B2)
      As an Admin
      I want to update operational settings (pricing, capacity)
      So that the system adapts to changing business needs

      Background:
        Given the Admin is logged in and authorized for the Configuration Menu

      # Basic Flow: Successful Update
      Scenario Outline: Admin updates configuration settings
        When the Admin changes the "<setting>" to "<new_value>"
        And saves the changes
        Then the system should validate the new value against business rules
        And update the database while maintaining data integrity
        And distribute the new config to relevant components
        And display a "Settings updated successfully" message

        Examples:
          | setting       | new_value |
          | Game Price    | 15.00     |
          | Zone Capacity | 100       |

      # Exception Flow I2: Data Integrity / Business Rule Violation
      Scenario: Attempt to save invalid configuration
        When the Admin attempts to set "Zone Capacity" to "-5"
        Then the system should reject the update
        And display an "Invalid numeric value" or "Business rule violation" error
        And the database should remain unchanged
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-B2.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_b2 @uml
Scenario: UC-B2 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: System Configuration Management (UC-B2)
      As an Admin
      I want to update operational settings (pricing, capacity)
      So that the system adapts to changing business needs

      Background:
        Given the Admin is logged in and authorized for the Configuration Menu

      # Basic Flow: Successful Update
      Scenario Outline: Admin updates configuration settings
        When the Admin changes the "<setting>" to "<new_value>"
        And saves the changes
        Then the system should validate the new value against business rules
        And update the database while maintaining data integrity
        And distribute the new config to relevant components
        And display a "Settings updated successfully" message

        Examples:
          | setting       | new_value |
          | Game Price    | 15.00     |
          | Zone Capacity | 100       |

      # Exception Flow I2: Data Integrity / Business Rule Violation
      Scenario: Attempt to save invalid configuration
        When the Admin attempts to set "Zone Capacity" to "-5"
        Then the system should reject the update
        And display an "Invalid numeric value" or "Business rule violation" error
        And the database should remain unchanged
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-B2_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-B3 – User Account Management
################################################################################

@uc_b3 @requirement
Scenario: UC-B3 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: User Account Management (UC-B3)
      As an Admin
      I want to create and manage staff accounts
      So that operational staff can access the system

      Background:
        Given the Admin is on the "User Management" screen

      # Basic Flow: Create New Account
      Scenario: Successfully create a new staff account
        When the Admin enters valid details for a new "Cashier"
        And clicks the "Save" button
        Then the system should verify the Admin's authorization level
        And create the new account in the database
        And generate a temporary password for the new user
        And display a "User created successfully" confirmation

      # Exception Flow I1: Unauthorized Operation
      Scenario: Unauthorized account creation attempt
        Given the acting user has the role "Manager"
        When the user attempts to create an account with role "Admin"
        Then the system should deny the request
        And display an "Insufficient privileges" error message

      # Alternative Flow A1: Password Reset
      Scenario: Resetting a user's password
        When the Admin selects an existing user account
        And clicks "Reset Password"
        Then the system should generate a new temporary password
        And invalidate the old password immediately
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-B3.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_b3 @testcase
Scenario: UC-B3 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: User Account Management (UC-B3)
      As an Admin
      I want to create and manage staff accounts
      So that operational staff can access the system

      Background:
        Given the Admin is on the "User Management" screen

      # Basic Flow: Create New Account
      Scenario: Successfully create a new staff account
        When the Admin enters valid details for a new "Cashier"
        And clicks the "Save" button
        Then the system should verify the Admin's authorization level
        And create the new account in the database
        And generate a temporary password for the new user
        And display a "User created successfully" confirmation

      # Exception Flow I1: Unauthorized Operation
      Scenario: Unauthorized account creation attempt
        Given the acting user has the role "Manager"
        When the user attempts to create an account with role "Admin"
        Then the system should deny the request
        And display an "Insufficient privileges" error message

      # Alternative Flow A1: Password Reset
      Scenario: Resetting a user's password
        When the Admin selects an existing user account
        And clicks "Reset Password"
        Then the system should generate a new temporary password
        And invalidate the old password immediately
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-B3.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_b3 @uml
Scenario: UC-B3 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: User Account Management (UC-B3)
      As an Admin
      I want to create and manage staff accounts
      So that operational staff can access the system

      Background:
        Given the Admin is on the "User Management" screen

      # Basic Flow: Create New Account
      Scenario: Successfully create a new staff account
        When the Admin enters valid details for a new "Cashier"
        And clicks the "Save" button
        Then the system should verify the Admin's authorization level
        And create the new account in the database
        And generate a temporary password for the new user
        And display a "User created successfully" confirmation

      # Exception Flow I1: Unauthorized Operation
      Scenario: Unauthorized account creation attempt
        Given the acting user has the role "Manager"
        When the user attempts to create an account with role "Admin"
        Then the system should deny the request
        And display an "Insufficient privileges" error message

      # Alternative Flow A1: Password Reset
      Scenario: Resetting a user's password
        When the Admin selects an existing user account
        And clicks "Reset Password"
        Then the system should generate a new temporary password
        And invalidate the old password immediately
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-B3_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-B4 – Financial Operations (Points / Refunds)
################################################################################

@uc_b4 @requirement
Scenario: UC-B4 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Financial Operations (UC-B4)
      As an Operator (Cashier, Manager)
      I want to load points or process refunds
      So that customer balances are accurate

      # Basic Flow: Process Transactions
      Scenario Outline: Processing financial transactions
        Given the Operator enters a valid customer ID or Transaction ID
        When the Operator processes a "<transaction_type>" of amount "<amount>"
        And confirms the action
        Then the system should verify the Operator's limit/authority
        And perform the transaction atomically in the database
        And log the action in the "Financial Journal"
        And display a "Transaction Complete" message

        Examples:
          | transaction_type | amount |
          | Load Points      | 500    |
          | Refund           | 50.00  |

      # Exception Flow I2: Negative Balance Check
      Scenario: Refund results in negative balance
        Given the customer has a balance of "10.00"
        When the Operator attempts a refund of "20.00"
        Then the system should reject the transaction
        And display an "Insufficient funds for refund" error

      # Exception Flow I3: Technical Rollback
      Scenario: Database error triggers rollback
        When the system attempts to save the transaction
        But a database connection error occurs
        Then the system should perform a "Rollback"
        And ensure the user balance is not affected
        And alert the technical team
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-B4.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_b4 @testcase
Scenario: UC-B4 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Financial Operations (UC-B4)
      As an Operator (Cashier, Manager)
      I want to load points or process refunds
      So that customer balances are accurate

      # Basic Flow: Process Transactions
      Scenario Outline: Processing financial transactions
        Given the Operator enters a valid customer ID or Transaction ID
        When the Operator processes a "<transaction_type>" of amount "<amount>"
        And confirms the action
        Then the system should verify the Operator's limit/authority
        And perform the transaction atomically in the database
        And log the action in the "Financial Journal"
        And display a "Transaction Complete" message

        Examples:
          | transaction_type | amount |
          | Load Points      | 500    |
          | Refund           | 50.00  |

      # Exception Flow I2: Negative Balance Check
      Scenario: Refund results in negative balance
        Given the customer has a balance of "10.00"
        When the Operator attempts a refund of "20.00"
        Then the system should reject the transaction
        And display an "Insufficient funds for refund" error

      # Exception Flow I3: Technical Rollback
      Scenario: Database error triggers rollback
        When the system attempts to save the transaction
        But a database connection error occurs
        Then the system should perform a "Rollback"
        And ensure the user balance is not affected
        And alert the technical team
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-B4.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_b4 @uml
Scenario: UC-B4 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Financial Operations (UC-B4)
      As an Operator (Cashier, Manager)
      I want to load points or process refunds
      So that customer balances are accurate

      # Basic Flow: Process Transactions
      Scenario Outline: Processing financial transactions
        Given the Operator enters a valid customer ID or Transaction ID
        When the Operator processes a "<transaction_type>" of amount "<amount>"
        And confirms the action
        Then the system should verify the Operator's limit/authority
        And perform the transaction atomically in the database
        And log the action in the "Financial Journal"
        And display a "Transaction Complete" message

        Examples:
          | transaction_type | amount |
          | Load Points      | 500    |
          | Refund           | 50.00  |

      # Exception Flow I2: Negative Balance Check
      Scenario: Refund results in negative balance
        Given the customer has a balance of "10.00"
        When the Operator attempts a refund of "20.00"
        Then the system should reject the transaction
        And display an "Insufficient funds for refund" error

      # Exception Flow I3: Technical Rollback
      Scenario: Database error triggers rollback
        When the system attempts to save the transaction
        But a database connection error occurs
        Then the system should perform a "Rollback"
        And ensure the user balance is not affected
        And alert the technical team
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-B4_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-B5 – Reporting & Analytics
################################################################################

@uc_b5 @requirement
Scenario: UC-B5 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Reporting and Analytics (UC-B5)
      As a Manager or Admin
      I want to view performance reports
      So that I can make informed operational decisions

      Background:
        Given the user is logged in and on the "Reports" panel

      # Basic Flow: Generate Report
      Scenario: Generating a performance report
        When the user selects "Daily Revenue Report" for the current date
        And clicks "Generate Report"
        Then the system should check for valid cached data
        And retrieve data from Cache or Database accordingly
        And display the report within "5 seconds"

      # Exception Flow I1: Unauthorized Report Access
      Scenario: Unauthorized access to sensitive reports
        Given the user has the role "Manager"
        When the user attempts to access the "Full Audit Log" (Admin only)
        Then the system should deny access
        And display an "Access Denied" error message

      # Alternative Flow A2: PDF Export
      Scenario: Exporting report to PDF
        Given a report is currently displayed
        When the user clicks "Download as PDF"
        Then the system should generate a PDF file
        And trigger the download
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-B5.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_b5 @testcase
Scenario: UC-B5 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Reporting and Analytics (UC-B5)
      As a Manager or Admin
      I want to view performance reports
      So that I can make informed operational decisions

      Background:
        Given the user is logged in and on the "Reports" panel

      # Basic Flow: Generate Report
      Scenario: Generating a performance report
        When the user selects "Daily Revenue Report" for the current date
        And clicks "Generate Report"
        Then the system should check for valid cached data
        And retrieve data from Cache or Database accordingly
        And display the report within "5 seconds"

      # Exception Flow I1: Unauthorized Report Access
      Scenario: Unauthorized access to sensitive reports
        Given the user has the role "Manager"
        When the user attempts to access the "Full Audit Log" (Admin only)
        Then the system should deny access
        And display an "Access Denied" error message

      # Alternative Flow A2: PDF Export
      Scenario: Exporting report to PDF
        Given a report is currently displayed
        When the user clicks "Download as PDF"
        Then the system should generate a PDF file
        And trigger the download
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-B5.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_b5 @uml
Scenario: UC-B5 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Reporting and Analytics (UC-B5)
      As a Manager or Admin
      I want to view performance reports
      So that I can make informed operational decisions

      Background:
        Given the user is logged in and on the "Reports" panel

      # Basic Flow: Generate Report
      Scenario: Generating a performance report
        When the user selects "Daily Revenue Report" for the current date
        And clicks "Generate Report"
        Then the system should check for valid cached data
        And retrieve data from Cache or Database accordingly
        And display the report within "5 seconds"

      # Exception Flow I1: Unauthorized Report Access
      Scenario: Unauthorized access to sensitive reports
        Given the user has the role "Manager"
        When the user attempts to access the "Full Audit Log" (Admin only)
        Then the system should deny access
        And display an "Access Denied" error message

      # Alternative Flow A2: PDF Export
      Scenario: Exporting report to PDF
        Given a report is currently displayed
        When the user clicks "Download as PDF"
        Then the system should generate a PDF file
        And trigger the download
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-B5_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-B6 – Backend User Session Initiation
################################################################################

@uc_b6 @requirement
Scenario: UC-B6 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Backend User Session Initiation (UC-B6)
      As the Backend System
      I want to process session start requests from KioskClients
      So that users can start using services if they have enough balance

      # Basic Flow: Successful Session Authorization
      Scenario: API validates balance and authorizes session
        Given a "Start Session" request is received from a KioskClient
        And the request contains a valid "Card ID" and "Game ID"
        When the Backend checks the user's wallet
        And confirms the balance is greater than the "Game Cost"
        Then the Backend should deduct the cost
        And create a financial log entry
        And send a "Session Authorized" response

      # Alternative Flow A1: Insufficient Balance
      Scenario: API rejects session due to insufficient funds
        Given a "Start Session" request is received
        When the user's balance is less than the "Game Cost"
        Then the Backend should send an "Insufficient Funds" error
        And the wallet balance should remain unchanged

      # Exception Flow I2: Latency / Timeout
      Scenario: Real-time response requirement
        When the Backend processes the session request
        Then the response must be sent within "1 second"
        And if processing exceeds this threshold, a timeout error should be logged
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-B6.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_b6 @testcase
Scenario: UC-B6 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Backend User Session Initiation (UC-B6)
      As the Backend System
      I want to process session start requests from KioskClients
      So that users can start using services if they have enough balance

      # Basic Flow: Successful Session Authorization
      Scenario: API validates balance and authorizes session
        Given a "Start Session" request is received from a KioskClient
        And the request contains a valid "Card ID" and "Game ID"
        When the Backend checks the user's wallet
        And confirms the balance is greater than the "Game Cost"
        Then the Backend should deduct the cost
        And create a financial log entry
        And send a "Session Authorized" response

      # Alternative Flow A1: Insufficient Balance
      Scenario: API rejects session due to insufficient funds
        Given a "Start Session" request is received
        When the user's balance is less than the "Game Cost"
        Then the Backend should send an "Insufficient Funds" error
        And the wallet balance should remain unchanged

      # Exception Flow I2: Latency / Timeout
      Scenario: Real-time response requirement
        When the Backend processes the session request
        Then the response must be sent within "1 second"
        And if processing exceeds this threshold, a timeout error should be logged
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-B6.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_b6 @uml
Scenario: UC-B6 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Backend User Session Initiation (UC-B6)
      As the Backend System
      I want to process session start requests from KioskClients
      So that users can start using services if they have enough balance

      # Basic Flow: Successful Session Authorization
      Scenario: API validates balance and authorizes session
        Given a "Start Session" request is received from a KioskClient
        And the request contains a valid "Card ID" and "Game ID"
        When the Backend checks the user's wallet
        And confirms the balance is greater than the "Game Cost"
        Then the Backend should deduct the cost
        And create a financial log entry
        And send a "Session Authorized" response

      # Alternative Flow A1: Insufficient Balance
      Scenario: API rejects session due to insufficient funds
        Given a "Start Session" request is received
        When the user's balance is less than the "Game Cost"
        Then the Backend should send an "Insufficient Funds" error
        And the wallet balance should remain unchanged

      # Exception Flow I2: Latency / Timeout
      Scenario: Real-time response requirement
        When the Backend processes the session request
        Then the response must be sent within "1 second"
        And if processing exceeds this threshold, a timeout error should be logged
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-B6_Sequence.txt"
  And The file should contain valid PlantUML code
