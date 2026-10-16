################################################################################
# UC-US06 – View Personal Information
################################################################################

@uc_us06 @requirement
Scenario: UC-US06 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: View Personal Information (UC-US06)
      As a user
      I want to view my personal information
      So that I can verify my registered profile details

      Background:
        Given the user is logged into the system
        And the user is on the Profile screen

      Scenario: Successfully view personal information
        When the user opens the Personal Information section
        Then the system should display the user's full name
        And display the user's phone number
        And display the user's email in masked format
        And display the password in masked format

      Scenario: User accesses profile screen
        When the user navigates to the Profile screen
        Then the Personal Information section should be displayed automatically

      Scenario: User expands personal information
        When the user clicks the Personal Information section
        Then the section should be expanded

      Scenario: User attempts to access another user's information
        When the user attempts to access another user's personal information
        Then the system should deny access
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US06.md"
  And The file should contain at least "5" Functional Requirements (FR)

################################################################################

@uc_us06 @testcase
Scenario: UC-US06 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: View Personal Information (UC-US06)

      Scenario: View profile
        Then the system displays all personal information

      Scenario: Email is masked
        Then the email should not be displayed in plain text

      Scenario: Password is masked
        Then the password should not be displayed in plain text

      Scenario: Unauthorized access
        Then the system should deny access
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US06.md"
  And The file should contain at least "4" Test Cases (TC)

################################################################################

@uc_us06 @uml
Scenario: UC-US06 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: View Personal Information (UC-US06)

      Scenario: View personal information
        When the user opens the profile page
        Then the system retrieves personal information
        And displays the profile information
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US06_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US07 – Edit Personal Information
################################################################################

@uc_us07 @requirement
Scenario: UC-US07 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Edit Personal Information (UC-US07)
      As a user
      I want to edit my personal information
      So that I can keep my profile up to date

      Background:
        Given the user is on the Personal Information screen

      Scenario: Successfully update a personal information field
        When the user clicks the "Edit" button for a field
        And enters a valid value
        And clicks the "Save" button
        Then the system should update the selected information

      Scenario: Editing without clicking Edit
        When the user attempts to modify a field without clicking Edit
        Then the system should prevent editing

      Scenario: Empty full name
        When the user saves an empty full name
        Then the system should display "Bu alan zorunludur."

      Scenario: Empty phone number
        When the user saves an empty phone number
        Then the system should display "Bu alan zorunludur."

      Scenario: Existing phone number
        When the user enters a phone number already registered
        Then the system should display "Telefon numarası sistemde kayıtlıdır."

      Scenario: Invalid phone number format
        When the user enters a phone number without country code
        Then the system should display "Alanlar doğru formatta girilmelidir."

      Scenario: Invalid email format
        When the user enters an invalid email
        Then the system should display "Alanlar doğru formatta girilmelidir."

      Scenario: Cancel editing
        When the user clicks the Cancel button
        Then the system should discard all changes
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US07.md"
  And The file should contain at least "8" Functional Requirements (FR)

################################################################################

@uc_us07 @testcase
Scenario: UC-US07 Test Case Generation
Given The BDD text to be analyzed is:
"""
Feature: Edit Personal Information (UC-US07)

Scenario: Successful update
Scenario: Empty full name
Scenario: Empty phone number
Scenario: Existing phone number
Scenario: Invalid phone format
Scenario: Invalid email
Scenario: Cancel editing
"""
When AI extracts detailed test cases from the BDD scenario
Then The output should be saved as "TestCases_UC-US07.md"
And The file should contain at least "7" Test Cases (TC)

################################################################################

@uc_us07 @uml
Scenario: UC-US07 UML Diagram Generation - Sequence
Given The BDD text to be analyzed is:
"""
Feature: Edit Personal Information (UC-US07)

Scenario: Successful update
When the user edits profile information
Then the system validates the data
And updates the profile
"""
When AI generates a "Sequence Diagram" from the BDD scenario
Then The output should be saved as "UML_UC-US07_Sequence.txt"
And The file should contain valid PlantUML code
################################################################################
# UC-US08 – View Address Information
################################################################################

@uc_us08 @requirement
Scenario: UC-US08 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: View Address Information (UC-US08)
      As a user
      I want to view my address information
      So that I can verify my saved address

      Background:
        Given the user is on the Personal Information screen

      Scenario: View address information
        When the user opens the Address Information section
        Then the system should display province
        And display district
        And display neighborhood

      Scenario: No address exists
        When the user has no saved address
        Then the address fields should be displayed empty

      Scenario: Address is read-only
        When the user views address information
        Then the address fields should not be editable
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US08.md"
  And The file should contain at least "3" Functional Requirements (FR)

################################################################################

@uc_us08 @testcase
Scenario: UC-US08 Test Case Generation
Given The BDD text to be analyzed is:
"""
Feature: View Address Information (UC-US08)

Scenario: View address
Scenario: Empty address
Scenario: Read-only address
"""
When AI extracts detailed test cases from the BDD scenario
Then The output should be saved as "TestCases_UC-US08.md"
And The file should contain at least "3" Test Cases (TC)

################################################################################

@uc_us08 @uml
Scenario: UC-US08 UML Diagram Generation - Sequence
Given The BDD text to be analyzed is:
"""
Feature: View Address Information (UC-US08)

Scenario: View address
When the user opens the address section
Then the system retrieves address information
"""
When AI generates a "Sequence Diagram" from the BDD scenario
Then The output should be saved as "UML_UC-US08_Sequence.txt"
And The file should contain valid PlantUML code
################################################################################
# UC-US09 – Edit Address Information
################################################################################

@uc_us09 @requirement
Scenario: UC-US09 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Edit Address Information (UC-US09)
      As a user
      I want to edit my address information
      So that I can keep my address up to date

      Background:
        Given the user is on the Address Information screen

      Scenario: Successfully update address
        When the user edits province, district or neighborhood
        And clicks the Save button
        Then the system should save the updated address

      Scenario: Save district without province
        When the user enters a district without selecting a province
        Then the system should display "İl seçmeden ilçe bilgisi kaydedilemez."

      Scenario: Save neighborhood without district
        When the user enters a neighborhood without selecting a district
        Then the system should display "İlçe seçmeden mahalle bilgisi kaydedilemez."

      Scenario: Invalid district
        When the user selects a district that does not belong to the selected province
        Then the system should display "Seçilen ilçe, seçilen ile bağlı olmalıdır."

      Scenario: Invalid neighborhood
        When the user selects a neighborhood that does not belong to the selected district
        Then the system should display "Seçilen mahalle, seçilen ilçeye bağlı olmalıdır."

      Scenario: Province changed
        When the user changes the province
        Then the system should reset district and neighborhood
        And display "İl değiştiği için ilçe ve mahalle bilgileri sıfırlandı."

      Scenario: District changed
        When the user changes the district
        Then the system should reset neighborhood
        And display "İlçe değiştiği için mahalle bilgisi sıfırlandı."

      Scenario: Cancel editing
        When the user clicks Cancel
        Then the system should discard all changes
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US09.md"
  And The file should contain at least "13" Functional Requirements (FR)

################################################################################

@uc_us09 @testcase
Scenario: UC-US09 Test Case Generation
Given The BDD text to be analyzed is:
"""
Feature: Edit Address Information (UC-US09)

Scenario: Successful update
Scenario: District without province
Scenario: Neighborhood without district
Scenario: Invalid district
Scenario: Invalid neighborhood
Scenario: Province reset
Scenario: District reset
Scenario: Cancel editing
"""
When AI extracts detailed test cases from the BDD scenario
Then The output should be saved as "TestCases_UC-US09.md"
And The file should contain at least "8" Test Cases (TC)

################################################################################

@uc_us09 @uml
Scenario: UC-US09 UML Diagram Generation - Sequence
Given The BDD text to be analyzed is:
"""
Feature: Edit Address Information (UC-US09)

Scenario: Successful update
When the user edits address information
Then the system validates address hierarchy
And updates the address
"""
When AI generates a "Sequence Diagram" from the BDD scenario
Then The output should be saved as "UML_UC-US09_Sequence.txt"
And The file should contain valid PlantUML code
################################################################################
# UC-US10 – View Login Credentials
################################################################################

@uc_us10 @requirement
Scenario: UC-US10 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: View Login Credentials (UC-US10)
      As a user
      I want to view my login credentials
      So that I can verify my account information

      Background:
        Given the user is authenticated
        And the user is on the Profile screen

      # Basic Flow
      Scenario: Successfully view login credentials
        When the user opens the "Login & Security" section
        Then the system should display the user's phone number
        And display the password in masked format

      # Exception Flow
      Scenario: Unauthorized access
        When an unauthorized user attempts to access another user's login information
        Then the system should deny access

      # Business Rule Validation
      Scenario: Login credentials remain read-only
        When the user views the Login & Security section
        Then the phone number field should not be editable
        And the password field should not be editable
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US10.md"
  And The file should contain at least "3" Functional Requirements (FR)

################################################################################

@uc_us10 @testcase
Scenario: UC-US10 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: View Login Credentials (UC-US10)

      Scenario: View login credentials
        Then the system displays the phone number
        And displays the password in masked format

      Scenario: Read-only login credentials
        Then the phone number cannot be edited
        And the password cannot be edited

      Scenario: Unauthorized access
        Then the system denies access
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US10.md"
  And The file should contain at least "3" Test Cases (TC)

################################################################################

@uc_us10 @uml
Scenario: UC-US10 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: View Login Credentials (UC-US10)

      Background:
        Given the user is authenticated

      Scenario: View login credentials
        When the user opens the Login & Security section
        Then the system retrieves the login credentials
        And displays the phone number
        And displays the password in masked format
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US10_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US11 – Edit Login Credentials
################################################################################

@uc_us11 @requirement
Scenario: UC-US11 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Edit Login Credentials (UC-US11)
      As a user
      I want to update my phone number and password
      So that I can keep my account secure

      Background:
        Given the user is authenticated
        And the user is on the Login & Security screen

      # Basic Flow 1: Successful phone number update
      Scenario: Update phone number successfully
        When the user clicks the "Edit" button for the phone number
        And enters a unique phone number with country code
        And clicks the "Save" button
        Then the system should redirect the user to the SMS verification screen
        And require successful SMS verification
        And update the phone number after successful verification
        And notify the user that the update was completed successfully

      # Basic Flow 2: Successful password update
      Scenario: Update password successfully
        When the user clicks the "Edit" button for the password
        And enters a valid new password
        And enters the same password confirmation
        And clicks the "Save" button
        Then the system should update the password
        And notify the user that the update was completed successfully

      # Exception Flow 1
      Scenario: Phone number is empty
        When the user leaves the phone number field empty
        And clicks the "Save" button
        Then the system should prevent the update
        And display "Bu alan zorunludur."

      # Exception Flow 2
      Scenario: Invalid phone number format
        When the user enters a phone number without country code
        And clicks the "Save" button
        Then the system should prevent the update
        And display "Alanlar doğru formatta girilmelidir."

      # Exception Flow 3
      Scenario: Existing phone number
        When the user enters a phone number already registered
        And clicks the "Save" button
        Then the system should prevent the update
        And display "Telefon numarası sistemde kayıtlıdır."

      # Exception Flow 4
      Scenario: SMS verification not completed
        When the user submits a valid phone number
        But does not complete SMS verification
        Then the system should not update the phone number

      # Exception Flow 5
      Scenario: Password is empty
        When the user leaves the new password field empty
        And clicks the "Save" button
        Then the system should prevent the update
        And display "Bu alan zorunludur."

      # Exception Flow 6
      Scenario: Password confirmation does not match
        When the user enters different values for password and password confirmation
        And clicks the "Save" button
        Then the system should prevent the update
        And display "Şifreler eşleşmemektedir."
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US11.md"
  And The file should contain at least "16" Functional Requirements (FR)

################################################################################

@uc_us11 @testcase
Scenario: UC-US11 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Edit Login Credentials (UC-US11)

      Scenario: Successful phone number update
        Then the system updates the phone number after SMS verification

      Scenario: Successful password update
        Then the system updates the password

      Scenario: Empty phone number
        Then the system displays "Bu alan zorunludur."

      Scenario: Invalid phone number format
        Then the system displays "Alanlar doğru formatta girilmelidir."

      Scenario: Existing phone number
        Then the system displays "Telefon numarası sistemde kayıtlıdır."

      Scenario: SMS verification not completed
        Then the phone number is not updated

      Scenario: Empty password
        Then the system displays "Bu alan zorunludur."

      Scenario: Password mismatch
        Then the system displays "Şifreler eşleşmemektedir."
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US11.md"
  And The file should contain at least "8" Test Cases (TC)

################################################################################

@uc_us11 @uml
Scenario: UC-US11 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Edit Login Credentials (UC-US11)

      Background:
        Given the user is authenticated

      Scenario: Successful phone number update
        When the user updates the phone number
        Then the system validates the phone number
        And redirects the user to SMS verification
        And updates the phone number after successful verification

      Scenario: Successful password update
        When the user updates the password
        Then the system validates the password
        And updates the password

      Scenario: Validation failure
        When the user submits invalid login credential information
        Then the system rejects the update
        And displays the appropriate validation message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US11_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US12 – View Device History
################################################################################

@uc_us12 @requirement
Scenario: UC-US12 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: View Device History (UC-US12)
      As a user
      I want to view my device history
      So that I can track which devices have accessed my account

      Background:
        Given the user is logged in
        And the user is on the "Login & Security" page

      Scenario: Successfully viewing device history
        When the user opens the device history section
        Then the system should automatically display the user's device history
        And each record should include the device name
        And each record should include the operating system
        And each record should include the login date and time
        And only the user's own session history should be displayed
        And the records should be read-only

      Scenario: No device history available
        Given the user has no recorded device history
        When the user opens the device history section
        Then the system should display
          "Henüz görüntülenecek cihaz geçmişi bulunmamaktadır."

      Scenario: Attempt to modify device history
        When the user attempts to edit a device history record
        Then the system should prevent the modification

      Scenario: Attempt to delete a device history record
        When the user attempts to delete a device history record
        Then the system should prevent the deletion
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US12.md"
  And The file should contain at least "6" Functional Requirements (FR)

################################################################################

@uc_us12 @testcase
Scenario: UC-US12 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: View Device History (UC-US12)

      Background:
        Given the user is logged in

      Scenario: View device history
        When the user opens the device history section
        Then the system displays all available device history records

      Scenario: No device history
        Given the user has no device history
        When the user opens the device history section
        Then the system displays
          "Henüz görüntülenecek cihaz geçmişi bulunmamaktadır."

      Scenario: Edit attempt
        When the user attempts to edit a device history record
        Then the system prevents editing

      Scenario: Delete attempt
        When the user attempts to delete a device history record
        Then the system prevents deletion
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US12.md"
  And The file should contain at least "4" Test Cases (TC)

################################################################################

@uc_us12 @uml
Scenario: UC-US12 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: View Device History (UC-US12)

      Background:
        Given the user is logged in

      Scenario: Successfully viewing device history
        When the user opens the device history section
        Then the system retrieves the user's device history
        And displays the history records
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US12_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US13 – View Privacy Policy and KVKK Information
################################################################################

@uc_us13 @requirement
Scenario: UC-US13 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: View Privacy Policy and KVKK Information (UC-US13)
      As a user
      I want to view the Privacy Policy and KVKK information
      So that I can understand how my personal data is processed and stored

      Background:
        Given the user is logged in
        And the user is on the "Login & Security" page

      Scenario: View Privacy Policy
        When the user selects "Privacy Policy"
        Then the system should display the latest Privacy Policy
        And the content should be read-only

      Scenario: View KVKK Information
        When the user selects "KVKK Information"
        Then the system should display the latest KVKK Information
        And the content should be read-only

      Scenario: Return from legal document
        Given a legal document is open
        When the user closes the document
        Then the system should return the user to the Login & Security page

      Scenario: Legal document cannot be loaded
        When the requested legal document cannot be loaded
        Then the system should display
          "İlgili metin şu anda görüntülenemiyor."
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US13.md"
  And The file should contain at least "6" Functional Requirements (FR)

################################################################################

@uc_us13 @testcase
Scenario: UC-US13 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: View Privacy Policy and KVKK Information (UC-US13)

      Background:
        Given the user is logged in

      Scenario: View Privacy Policy
        When the user selects "Privacy Policy"
        Then the Privacy Policy is displayed

      Scenario: View KVKK Information
        When the user selects "KVKK Information"
        Then the KVKK Information is displayed

      Scenario: Return to previous page
        When the user closes the legal document
        Then the Login & Security page is displayed

      Scenario: Error while loading document
        When the legal document cannot be loaded
        Then the system displays
          "İlgili metin şu anda görüntülenemiyor."
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US13.md"
  And The file should contain at least "5" Test Cases (TC)

################################################################################

@uc_us13 @uml
Scenario: UC-US13 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: View Privacy Policy and KVKK Information (UC-US13)

      Background:
        Given the user is logged in

      Scenario: View legal document
        When the user selects a legal document
        Then the system retrieves the latest version
        And displays it in read-only mode
        And returns the user to the previous screen after closing
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US13_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US14 – Delete User Account
################################################################################

@uc_us14 @requirement
Scenario: UC-US14 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Delete User Account (UC-US14)
      As a user
      I want to permanently delete my account
      So that I can stop using the application

      Background:
        Given the user is logged in
        And the user is on the "Login & Security" page

      Scenario: Successfully deleting an account
        When the user selects "Delete My Account"
        Then the system should display a confirmation warning
        When the user selects "Continue"
        Then the system should display the account deletion form
        When the user enters a reason for leaving
        And enters their full name
        And enters their phone number
        And confirms the deletion
        Then the system should permanently delete the account
        And log the user out
        And redirect the user to the login screen

      Scenario: User cancels account deletion
        When the user selects "Delete My Account"
        And selects "Cancel"
        Then the system should cancel the deletion process
        And return the user to the Login & Security page

      Scenario: Account deletion with missing reason
        When the user leaves the reason field empty
        And submits the deletion form
        Then the system should prevent deletion
        And display "Bu alan zorunludur."

      Scenario: Account deletion with missing full name
        When the user leaves the full name field empty
        And submits the deletion form
        Then the system should prevent deletion
        And display "Bu alan zorunludur."

      Scenario: Account deletion with missing phone number
        When the user leaves the phone number field empty
        And submits the deletion form
        Then the system should prevent deletion
        And display "Bu alan zorunludur."

      Scenario: Return from account deletion form
        When the user selects the Back option
        Then the system should return to the previous screen
        And no deletion should occur

      Scenario: Login after account deletion
        Given the user's account has been deleted
        When the user attempts to log in
        Then the system should display
          "Bu hesap silinmiştir."
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US14.md"
  And The file should contain at least "15" Functional Requirements (FR)

################################################################################

@uc_us14 @testcase
Scenario: UC-US14 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Delete User Account (UC-US14)

      Background:
        Given the user is logged in

      Scenario: Successfully delete account
        When the user completes the deletion form correctly
        Then the account is permanently deleted

      Scenario: Cancel deletion
        When the user selects Cancel
        Then the deletion process is cancelled

      Scenario: Missing reason
        When the user leaves the reason field empty
        Then the system displays "Bu alan zorunludur."

      Scenario: Missing full name
        When the user leaves the full name field empty
        Then the system displays "Bu alan zorunludur."

      Scenario: Missing phone number
        When the user leaves the phone number field empty
        Then the system displays "Bu alan zorunludur."

      Scenario: Deleted account login
        Given the account has been deleted
        When the user logs in
        Then the system displays "Bu hesap silinmiştir."
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US14.md"
  And The file should contain at least "8" Test Cases (TC)

################################################################################

@uc_us14 @uml
Scenario: UC-US14 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Delete User Account (UC-US14)

      Background:
        Given the user is logged in

      Scenario: Successfully delete account
        When the user requests account deletion
        Then the system displays a confirmation dialog
        When the user confirms
        Then the system displays the deletion form
        When the user submits valid information
        Then the system permanently deletes the account
        And logs the user out
        And redirects the user to the login page
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US14_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US15 – View Informational Texts (Notifications & About)
################################################################################

@uc_us15 @requirement
Scenario: UC-US15 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: View Informational Texts (UC-US15)
      As a user
      I want to view Notifications and About information
      So that I can learn about the application and support processes

      Background:
        Given the user is logged in
        And the user is on the Profile page

      Scenario: View notifications
        When the user opens the Notifications section
        Then the system should display the informational text
        And the content should be read-only

      Scenario: View Help & Support information
        When the user opens the Help & Support section
        Then the system should display the informational text
        And the content should be read-only

      Scenario: View About information
        When the user opens the About section
        Then the system should display the informational text
        And the content should be read-only

      Scenario: Informational text exceeds screen size
        Given the informational text is longer than the screen
        When the user views the content
        Then the system should allow scrolling

      Scenario: Exit informational page
        When the user leaves the informational page
        Then no changes should be saved
        And no data should be modified
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US15.md"
  And The file should contain at least "6" Functional Requirements (FR)

################################################################################

@uc_us15 @testcase
Scenario: UC-US15 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: View Informational Texts (UC-US15)

      Background:
        Given the user is logged in

      Scenario: View Notifications
        When the user opens Notifications
        Then the informational text is displayed

      Scenario: View Help & Support
        When the user opens Help & Support
        Then the informational text is displayed

      Scenario: View About
        When the user opens About
        Then the informational text is displayed

      Scenario: Read-only content
        When the user attempts to edit the content
        Then the system prevents editing

      Scenario: Scroll long content
        Given the content exceeds screen size
        When the user views the content
        Then scrolling is enabled
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US15.md"
  And The file should contain at least "6" Test Cases (TC)

################################################################################

@uc_us15 @uml
Scenario: UC-US15 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: View Informational Texts (UC-US15)

      Background:
        Given the user is logged in

      Scenario: View informational content
        When the user selects an informational section
        Then the system retrieves the latest content
        And displays it in read-only mode
        And allows scrolling if necessary
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US15_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US16 – Payment Method Selection
################################################################################

@uc_us16 @requirement
Scenario: UC-US16 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Payment Method Selection (UC-US16)
      As a user
      I want to view the available payment methods
      So that I can decide how to pay

      Background:
        Given the user is logged into the application
        And the user is on Profile > Payments

      # Basic Flow: View payment methods
      Scenario: Display available payment methods
        When the user opens the Payments section
        Then the system should display the available payment methods
        And display "Saved Card Payment"
        And display "Continue Without Saving Card"

      # Basic Flow: Select saved card payment
      Scenario: Select saved card payment
        When the user selects "Saved Card Payment"
        Then the system should mark the option as selected
        And allow the user to continue to the payment step

      # Basic Flow: Select payment without saving card
      Scenario: Select payment without saving card
        When the user selects "Continue Without Saving Card"
        Then the system should mark the option as selected
        And allow the user to continue to the payment step
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US16.md"
  And The file should contain at least "6" Functional Requirements (FR)

################################################################################

@uc_us16 @testcase
Scenario: UC-US16 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Payment Method Selection (UC-US16)
      As a user
      I want to view the available payment methods
      So that I can decide how to pay

      Background:
        Given the user is on the Payments page

      Scenario: Display payment methods
        When the user opens the Payments section
        Then the system should display all available payment methods

      Scenario: Select saved card payment
        When the user selects "Saved Card Payment"
        Then the selected payment method should be stored

      Scenario: Select payment without saving card
        When the user selects "Continue Without Saving Card"
        Then the selected payment method should be stored
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US16.md"
  And The file should contain at least "3" Test Cases (TC)

################################################################################

@uc_us16 @uml
Scenario: UC-US16 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Payment Method Selection (UC-US16)
      As a user
      I want to view the available payment methods
      So that I can decide how to pay

      Background:
        Given the user is on the Payments page

      Scenario: User selects a payment method
        When the user opens the Payments section
        Then the system displays available payment methods
        When the user selects a payment method
        Then the system stores the selected payment method
        And allows the user to continue to the payment process
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US16_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US17 – Payment Without Saving Card
################################################################################

@uc_us17 @requirement
Scenario: UC-US17 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Payment Without Saving Card (UC-US17)
      As a user
      I want to pay without saving my card
      So that my card information is not stored in the system

      Background:
        Given the user is on the payment method screen
        And the user selects "Continue Without Saving Card"

      # Basic Flow: Successful payment
      Scenario: Successful payment without saving card
        When the user enters a valid card number
        And enters a valid expiration date
        And enters a valid CVV
        And enters the cardholder name
        And clicks the "Pay" button
        Then the system should validate all mandatory card fields
        And process the payment successfully
        And notify the user that the payment is successful
        And ensure the entered card information is not stored
        And ensure the entered card is not added to the saved cards list

      # Exception Flow 1: Card number is empty
      Scenario: Payment with empty card number
        When the user leaves the card number field empty
        And clicks the "Pay" button
        Then the system should prevent the payment
        And display "Bu alan zorunludur."

      # Exception Flow 2: Expiration date is empty
      Scenario: Payment with empty expiration date
        When the user leaves the expiration date field empty
        And clicks the "Pay" button
        Then the system should prevent the payment
        And display "Bu alan zorunludur."

      # Exception Flow 3: CVV is empty
      Scenario: Payment with empty CVV
        When the user leaves the CVV field empty
        And clicks the "Pay" button
        Then the system should prevent the payment
        And display "Bu alan zorunludur."

      # Exception Flow 4: Cardholder name is empty
      Scenario: Payment with empty cardholder name
        When the user leaves the cardholder name field empty
        And clicks the "Pay" button
        Then the system should prevent the payment
        And display "Bu alan zorunludur."

      # Exception Flow 5: Invalid card information
      Scenario: Payment with invalid card information
        When the user enters invalid card information
        And clicks the "Pay" button
        Then the system should prevent the payment
        And display "Kart bilgileri geçerli değildir."
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US17.md"
  And The file should contain at least "9" Functional Requirements (FR)

################################################################################

@uc_us17 @testcase
Scenario: UC-US17 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Payment Without Saving Card (UC-US17)
      As a user
      I want to pay without saving my card
      So that my card information is not stored

      Background:
        Given the user selected "Continue Without Saving Card"

      Scenario: Successful payment
        When the user enters valid card information
        Then the payment should be completed successfully
        And the card information should not be stored

      Scenario: Empty mandatory card fields
        When the user leaves one or more mandatory fields empty
        Then the system should display "Bu alan zorunludur."

      Scenario: Invalid card information
        When the user enters invalid card information
        Then the system should display "Kart bilgileri geçerli değildir."

      Scenario: Card is not saved
        When the payment is completed successfully
        Then the entered card should not appear in the saved cards list

      Scenario: User notification after successful payment
        When the payment is completed successfully
        Then the system should notify the user
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US17.md"
  And The file should contain at least "6" Test Cases (TC)

################################################################################

@uc_us17 @uml
Scenario: UC-US17 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Payment Without Saving Card (UC-US17)
      As a user
      I want to pay without saving my card
      So that my card information is not be stored

      Background:
        Given the user selected "Continue Without Saving Card"

      Scenario: Successful payment
        When the user enters valid card information
        And clicks the "Pay" button
        Then the system validates the card information
        And processes the payment
        And completes the payment successfully
        And does not store the entered card information
        And notifies the user

      Scenario: Payment validation failure
        When the user submits invalid or incomplete card information
        Then the system rejects the payment
        And displays the appropriate validation message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US17_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US18 – Add New Payment Card
################################################################################

@uc_us18 @requirement
Scenario: UC-US18 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Add New Payment Card (UC-US18)
      As a user
      I want to add a new payment card
      So that I can use it for future payments

      Background:
        Given the user is logged into the application
        And the user is on Profile > Payments

      # Basic Flow: Successfully add a new card
      Scenario: Successfully add a new payment card
        When the user clicks the "Add Payment Method" button
        And enters a valid card number
        And enters a valid expiration date
        And enters a valid CVV
        And enters the cardholder name
        And clicks the "Save Card" button
        Then the system should validate all mandatory fields
        And save the payment card
        And add the card to the saved cards list

      # Exception Flow 1: Card number is empty
      Scenario: Add card with empty card number
        When the user leaves the card number field empty
        And clicks the "Save Card" button
        Then the system should prevent saving the card
        And display "Bu alan zorunludur."

      # Exception Flow 2: Expiration date is empty
      Scenario: Add card with empty expiration date
        When the user leaves the expiration date field empty
        And clicks the "Save Card" button
        Then the system should prevent saving the card
        And display "Bu alan zorunludur."

      # Exception Flow 3: CVV is empty
      Scenario: Add card with empty CVV
        When the user leaves the CVV field empty
        And clicks the "Save Card" button
        Then the system should prevent saving the card
        And display "Bu alan zorunludur."

      # Exception Flow 4: Cardholder name is empty
      Scenario: Add card with empty cardholder name
        When the user leaves the cardholder name field empty
        And clicks the "Save Card" button
        Then the system should prevent saving the card
        And display "Bu alan zorunludur."

      # Exception Flow 5: Invalid card information
      Scenario: Add card with invalid card information
        When the user enters invalid card information
        And clicks the "Save Card" button
        Then the system should prevent saving the card
        And display "Kart bilgileri geçerli değildir."

      # Basic Flow: Add multiple cards
      Scenario: Successfully add multiple payment cards
        Given the user already has saved payment cards
        When the user adds another valid payment card
        Then the system should save the new card
        And display it in the saved cards list
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US18.md"
  And The file should contain at least "10" Functional Requirements (FR)

################################################################################

@uc_us18 @testcase
Scenario: UC-US18 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Add New Payment Card (UC-US18)
      As a user
      I want to add a payment card
      So that I can use it later

      Background:
        Given the user is on the Add Payment Card page

      Scenario: Successfully add a payment card
        When the user enters valid card information
        Then the system should save the card
        And display it in the saved cards list

      Scenario: Empty mandatory fields
        When the user leaves one or more mandatory fields empty
        Then the system should display "Bu alan zorunludur."

      Scenario: Invalid card information
        When the user enters invalid card information
        Then the system should display "Kart bilgileri geçerli değildir."

      Scenario: Add multiple cards
        When the user saves another valid payment card
        Then the system should add the new card to the saved cards list
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US18.md"
  And The file should contain at least "6" Test Cases (TC)

################################################################################

@uc_us18 @uml
Scenario: UC-US18 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Add New Payment Card (UC-US18)
      As a user
      I want to add a payment card
      So that I can use it for future payments

      Background:
        Given the user is on the Add Payment Card page

      Scenario: Successfully add a payment card
        When the user enters valid card information
        And clicks the "Save Card" button
        Then the system validates the information
        And saves the payment card
        And updates the saved cards list

      Scenario: Invalid card information
        When the user submits invalid card information
        Then the system rejects the request
        And displays the appropriate validation message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US18_Sequence.txt"
  And The file should contain valid PlantUML code

################################################################################
# UC-US19 – View Saved Payment Cards
################################################################################

@uc_us19 @requirement
Scenario: UC-US19 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: View Saved Payment Cards (UC-US19)
      As a user
      I want to view my saved payment cards
      So that I can see which cards are available

      Background:
        Given the user is logged into the application
        And the user is on Profile > Payments

      # Basic Flow: Display saved cards
      Scenario: Display saved payment cards
        When the user opens the Payments section
        Then the system should display all saved payment cards
        And display each card with a masked card number

      # Basic Flow: Select a saved card
      Scenario: Select a saved payment card
        When the user clicks a saved payment card
        Then the system should open the selected card

      # Basic Flow: Display masked card information
      Scenario: Display masked card number
        When the saved cards are displayed
        Then the system should mask the card number
        And display only the last four digits
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US19.md"
  And The file should contain at least "5" Functional Requirements (FR)

################################################################################

@uc_us19 @testcase
Scenario: UC-US19 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: View Saved Payment Cards (UC-US19)
      As a user
      I want to view my saved payment cards
      So that I can manage my payment methods

      Background:
        Given the user is on the Payments page

      Scenario: Display saved cards
        When the user opens the Payments section
        Then the system should display all saved cards

      Scenario: Display masked card numbers
        When the cards are displayed
        Then each card number should be masked

      Scenario: Select a saved card
        When the user clicks a saved card
        Then the selected card should be opened
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US19.md"
  And The file should contain at least "3" Test Cases (TC)

################################################################################

@uc_us19 @uml
Scenario: UC-US19 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: View Saved Payment Cards (UC-US19)
      As a user
      I want to view my saved payment cards
      So that I can review my available payment methods

      Background:
        Given the user is on the Payments page

      Scenario: View saved payment cards
        When the user opens the Payments section
        Then the system retrieves the saved cards
        And displays the masked card information
        When the user selects a card
        Then the system displays the selected card
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US19_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US21 – Delete Saved Payment Card
################################################################################

@uc_us21 @requirement
Scenario: UC-US21 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Delete Saved Payment Card (UC-US21)
      As a user
      I want to delete one of my saved payment cards
      So that I can remove cards that I no longer use

      Background:
        Given the user is logged into the application
        And the user is on Profile > Payments
        And the user has at least one saved payment card

      # Basic Flow: Successfully delete a saved card
      Scenario: Successfully delete a saved payment card
        When the user selects a saved payment card
        Then the system should display the "Delete Card" action
        When the user clicks the "Delete Card" button
        Then the system should display a confirmation message
        When the user confirms the deletion
        Then the system should permanently remove the selected card
        And update the saved cards list

      # Exception Flow 1: User cancels deletion
      Scenario: Cancel card deletion
        When the user clicks the "Delete Card" button
        And the confirmation dialog is displayed
        And the user cancels the deletion
        Then the system should keep the selected card
        And close the confirmation dialog

      # Basic Flow: Display confirmation message
      Scenario: Display delete confirmation
        When the user selects the delete action
        Then the system should display
          "Kartı silmek istediğinize emin misiniz?"
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US21.md"
  And The file should contain at least "6" Functional Requirements (FR)

################################################################################

@uc_us21 @testcase
Scenario: UC-US21 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Delete Saved Payment Card (UC-US21)
      As a user
      I want to delete a saved payment card
      So that I can remove unused cards

      Background:
        Given the user has at least one saved payment card

      Scenario: Display delete action
        When the user selects a saved card
        Then the system should display the "Delete Card" button

      Scenario: Successfully delete a saved card
        When the user confirms the deletion
        Then the selected card should be removed permanently

      Scenario: Cancel deletion
        When the user cancels the deletion
        Then the selected card should remain in the saved cards list

      Scenario: Display confirmation message
        When the user initiates card deletion
        Then the system should display the confirmation message
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US21.md"
  And The file should contain at least "4" Test Cases (TC)

################################################################################

@uc_us21 @uml
Scenario: UC-US21 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Delete Saved Payment Card (UC-US21)
      As a user
      I want to delete a saved payment card
      So that I can remove unused cards

      Background:
        Given the user is on the Payments page

      Scenario: Successfully delete a saved payment card
        When the user selects a saved payment card
        And clicks the "Delete Card" button
        Then the system displays a confirmation dialog
        When the user confirms the deletion
        Then the system permanently removes the card
        And updates the saved cards list

      Scenario: Cancel deletion
        When the user cancels the deletion
        Then the system closes the confirmation dialog
        And keeps the selected card unchanged
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US21_Sequence.txt"
  And The file should contain valid PlantUML code