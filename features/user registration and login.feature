################################################################################
# UC-US01 – User Registration
################################################################################

@uc_us01 @requirement
Scenario: UC-US01 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: User Registration (UC-US01)
      As a user
      I want to register with my phone number and password
      So that I can start the registration process

      Background:
        Given the user is on the registration screen

      # Basic Flow: Successful Registration
      Scenario: Successful registration redirects user to SMS verification
        When the user enters a unique phone number with country code
        And enters a valid password
        And confirms the same password
        And optionally enters an email address
        And clicks the "Register" button
        Then the system should validate all mandatory fields
        And verify that the phone number is unique
        And redirect the user to the SMS verification screen

      # Exception Flow 1: Phone number is empty
      Scenario: Registration with empty phone number
        When the user leaves the phone number field empty
        And clicks the "Register" button
        Then the system should prevent registration
        And display "Bu alan zorunludur."

      # Exception Flow 2: Password is empty
      Scenario: Registration with empty password
        When the user leaves the password field empty
        And clicks the "Register" button
        Then the system should prevent registration
        And display "Bu alan zorunludur."

      # Exception Flow 3: Password confirmation is empty
      Scenario: Registration with empty password confirmation
        When the user leaves the password confirmation field empty
        And clicks the "Register" button
        Then the system should prevent registration
        And display "Bu alan zorunludur."

      # Exception Flow 4: Phone number already exists
      Scenario: Registration with an existing phone number
        When the user enters a phone number already registered in the system
        And clicks the "Register" button
        Then the system should prevent registration
        And display "Telefon numarası sistemde kayıtlıdır."

      # Exception Flow 5: Invalid phone number format
      Scenario: Registration with phone number without country code
        When the user enters a phone number without country code
        And clicks the "Register" button
        Then the system should prevent registration
        And display "Alanlar doğru formatta girilmelidir."

      # Exception Flow 6: Passwords do not match
      Scenario: Registration with different passwords
        When the user enters different values for password and password confirmation
        And clicks the "Register" button
        Then the system should prevent registration
        And display "Şifreler eşleşmemektedir."

      # Exception Flow 7: Password does not satisfy security rules
      Scenario Outline: Registration with invalid password
        When the user enters password "<password>"
        And enters the same password confirmation
        And clicks the "Register" button
        Then the system should prevent registration
        And display "<message>"

        Examples:
          | password | message |
          | abc      | Password must be between 4 and 8 characters and include uppercase, lowercase and special characters. |
          | ABCD     | Password must be between 4 and 8 characters and include uppercase, lowercase and special characters. |
          | Abcd     | Password must be between 4 and 8 characters and include uppercase, lowercase and special characters. |
          | Abc@12345| Password must be between 4 and 8 characters and include uppercase, lowercase and special characters. |
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US01.md"
  And The file should contain at least "10" Functional Requirements (FR)

################################################################################

@uc_us01 @testcase
Scenario: UC-US01 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: User Registration (UC-US01)
      As a user
      I want to register with my phone number and password
      So that I can start the registration process

      Background:
        Given the user is on the registration screen

      Scenario: Successful registration redirects user to SMS verification
        When the user enters a unique phone number with country code
        And enters a valid password
        And confirms the same password
        And optionally enters an email address
        And clicks the "Register" button
        Then the system should validate all mandatory fields
        And verify that the phone number is unique
        And redirect the user to the SMS verification screen

      Scenario: Registration with empty phone number
        When the user leaves the phone number field empty
        Then the system should display "Bu alan zorunludur."

      Scenario: Registration with empty password
        When the user leaves the password field empty
        Then the system should display "Bu alan zorunludur."

      Scenario: Registration with empty password confirmation
        When the user leaves the password confirmation field empty
        Then the system should display "Bu alan zorunludur."

      Scenario: Registration with an existing phone number
        When the user enters a phone number already registered
        Then the system should display "Telefon numarası sistemde kayıtlıdır."

      Scenario: Registration with phone number without country code
        When the user enters a phone number without country code
        Then the system should display "Alanlar doğru formatta girilmelidir."

      Scenario: Registration with different passwords
        When the user enters different passwords
        Then the system should display "Şifreler eşleşmemektedir."

      Scenario: Registration with invalid password format
        When the user enters a password that violates password rules
        Then the system should reject the registration
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US01.md"
  And The file should contain at least "8" Test Cases (TC)

################################################################################

@uc_us01 @uml
Scenario: UC-US01 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: User Registration (UC-US01)
      As a user
      I want to register with my phone number and password
      So that I can start the registration process

      Background:
        Given the user is on the registration screen

      Scenario: Successful registration redirects user to SMS verification
        When the user enters a unique phone number with country code
        And enters a valid password
        And confirms the same password
        And optionally enters an email address
        And clicks the "Register" button
        Then the system should validate all mandatory fields
        And verify that the phone number is unique
        And create a pending user registration
        And redirect the user to the SMS verification screen

      Scenario: Registration with validation errors
        When the user submits invalid registration data
        Then the system should reject the registration
        And display the appropriate validation message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US01_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US02 – SMS Phone Number Verification
################################################################################

@uc_us02 @requirement
Scenario: UC-US02 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: SMS Phone Number Verification (UC-US02)
      As a user
      I want to verify my registration using the SMS verification code sent to my phone number
      So that my account can be created

      Background:
        Given the user has successfully completed the registration form
        And an SMS verification code has been generated for the registered phone number
        And the user is on the SMS verification screen

      # Basic Flow: Successful SMS Verification
      Scenario: Successful SMS verification
        When the user enters a valid verification code before it expires
        And clicks the "Verify" button
        Then the system should validate the verification code
        And create the user account
        And redirect the user to the login screen

      # Exception Flow 1: Empty verification code
      Scenario: Verification code is empty
        When the user leaves the verification code field empty
        And clicks the "Verify" button
        Then the system should prevent the verification process
        And display "Bu alan zorunludur."

      # Exception Flow 2: Invalid verification code
      Scenario: Invalid verification code
        When the user enters an incorrect verification code
        And clicks the "Verify" button
        Then the system should prevent account creation
        And display "Geçersiz doğrulama kodu."

      # Exception Flow 3: Expired verification code
      Scenario: Expired verification code
        Given the verification code has expired
        When the user enters the expired verification code
        And clicks the "Verify" button
        Then the system should prevent account creation
        And display "Doğrulama kodunun süresi dolmuştur."

      # Exception Flow 4: Request a new verification code
      Scenario: Request a new verification code after expiration
        Given the verification code has expired
        When the user requests a new verification code
        Then the system should generate a new verification code
        And associate it with the registered phone number
        And send the new verification code via SMS

      # Business Rule Validation
      Scenario: Verification code is single-use
        Given the verification code has already been used successfully
        When the user enters the same verification code again
        Then the system should reject the verification

      # Business Rule Validation
      Scenario Outline: Verification code validity period
        Given the verification code was generated "<elapsed_time>" ago
        When the user enters the verification code
        Then the verification result should be "<result>"

        Examples:
          | elapsed_time      | result      |
          | 30 seconds        | successful  |
          | 1 minute          | successful  |
          | 2 minutes         | successful  |
          | 2 minutes 1 second| failed      |
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US02.md"
  And The file should contain at least "9" Functional Requirements (FR)

################################################################################

@uc_us02 @testcase
Scenario: UC-US02 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: SMS Phone Number Verification (UC-US02)

      Background:
        Given the user is on the SMS verification screen

      Scenario: Successful SMS verification
        When the user enters a valid verification code
        Then the system should create the user account

      Scenario: Verification code is empty
        When the user leaves the verification code field empty
        Then the system should display "Bu alan zorunludur."

      Scenario: Invalid verification code
        When the user enters an incorrect verification code
        Then the system should display "Geçersiz doğrulama kodu."

      Scenario: Expired verification code
        When the user enters an expired verification code
        Then the system should display "Doğrulama kodunun süresi dolmuştur."

      Scenario: Request new verification code
        When the user requests a new verification code
        Then the system should send a new SMS verification code
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US02.md"
  And The file should contain at least "6" Test Cases (TC)

################################################################################

@uc_us02 @uml
Scenario: UC-US02 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: SMS Phone Number Verification (UC-US02)

      Background:
        Given the user is on the SMS verification screen

      Scenario: Successful SMS verification
        When the user enters a valid verification code
        And clicks the "Verify" button
        Then the system validates the code
        And creates the user account
        And redirects the user to the login screen

      Scenario: Verification fails
        When the user submits an invalid or expired verification code
        Then the system rejects the verification
        And displays the appropriate validation message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US02_Sequence.txt"
  And The file should contain valid PlantUML code
################################################################################
# UC-US03 – View Privacy Notice and Terms of Use
################################################################################

@uc_us03 @requirement
Scenario: UC-US03 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: View Privacy Notice and Terms of Use (UC-US03)
      As a user
      I want to view the Privacy Notice and Terms of Use during registration
      So that I can review how my personal data is processed and the application's terms

      Background:
        Given the user is on the registration screen

      # Basic Flow
      Scenario: View Privacy Notice and Terms of Use
        When the user clicks the Privacy Notice or Terms of Use link
        Then the system should display the selected legal document
        And the registration process should remain active

      # Basic Flow
      Scenario: Return to registration screen
        Given the user is viewing a legal document
        When the user closes the document
        Then the system should return the user to the registration screen
        And preserve all previously entered registration information

      # Business Rule Validation
      Scenario: Continue registration without viewing legal documents
        When the user continues filling out the registration form without opening any legal document
        Then the system should allow the registration process to continue
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US03.md"
  And The file should contain at least "5" Functional Requirements (FR)

################################################################################

@uc_us03 @testcase
Scenario: UC-US03 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: View Privacy Notice and Terms of Use (UC-US03)

      Scenario: Display legal document
        When the user opens the Privacy Notice
        Then the system should display the document

      Scenario: Return to registration screen
        When the user closes the legal document
        Then the system should restore the registration screen

      Scenario: Preserve entered data
        When the user returns to the registration screen
        Then the previously entered form data should remain unchanged

      Scenario: Continue registration without viewing legal documents
        When the user does not open any legal document
        Then the registration process should continue
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US03.md"
  And The file should contain at least "4" Test Cases (TC)

################################################################################

@uc_us03 @uml
Scenario: UC-US03 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: View Privacy Notice and Terms of Use (UC-US03)

      Background:
        Given the user is on the registration screen

      Scenario: View legal documents
        When the user selects the Privacy Notice or Terms of Use
        Then the system displays the requested document
        And returns the user to the registration screen after closing it
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US03_Sequence.txt"
  And The file should contain valid PlantUML code
 ################################################################################
# UC-US04 – User Login
################################################################################

@uc_us04 @requirement
Scenario: UC-US04 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: User Login (UC-US04)

      As a user
      I want to log into the system using my phone number and password
      So that I can access the application.

      Background:
        Given the user is on the login screen

      # Basic Flow 1
      Scenario: View login screen
        Then the system should display the "Customer" and "Technician" role options
        And the "Customer" role should be selected by default

      # Basic Flow 2
      Scenario: Successful login
        Given the "Customer" role is selected
        When the user enters a registered phone number
        And enters the correct password
        And clicks the "Login" button
        Then the system should authenticate the user
        And redirect the user to the home screen

      # Basic Flow 3
      Scenario: Save last successful role
        Given the user logs in successfully using the "Technician" role
        Then the system should save the "Technician" role as the last successful role

      # Basic Flow 4
      Scenario: Display last successful role
        Given the user has previously logged in successfully
        When the user opens the login screen
        Then the system should display the last successful role as the default selection

      # Exception Flow 1
      Scenario: No role selected
        Given no role is selected
        When the user clicks the "Login" button
        Then the system should prevent the login process
        And display "Please select a role."

      # Exception Flow 2
      Scenario: Phone number is empty
        Given the "Customer" role is selected
        When the user leaves the phone number field empty
        And clicks the "Login" button
        Then the system should prevent the login process
        And display "This field is required."

      # Exception Flow 3
      Scenario: Password is empty
        Given the "Customer" role is selected
        When the user leaves the password field empty
        And clicks the "Login" button
        Then the system should prevent the login process
        And display "This field is required."

      # Exception Flow 4
      Scenario: Unregistered phone number
        Given the "Customer" role is selected
        When the user enters an unregistered phone number
        And enters any password
        And clicks the "Login" button
        Then the system should prevent the login process
        And display "Incorrect phone number or password."

      # Exception Flow 5
      Scenario: Incorrect password
        Given the "Customer" role is selected
        When the user enters a registered phone number
        And enters an incorrect password
        And clicks the "Login" button
        Then the system should prevent the login process
        And display "Incorrect phone number or password."
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US04.md"
  And The file should contain at least "11" Functional Requirements (FR)

################################################################################

@uc_us04 @testcase
Scenario: UC-US04 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: User Login (UC-US04)

      Scenario: View login screen
        Then the system should display the available user roles

      Scenario: Successful login
        When the user enters valid credentials
        Then the system should authenticate the user
        And redirect the user to the home screen

      Scenario: Save last successful role
        Then the system should save the last successful role

      Scenario: Display last successful role
        Then the system should display the last successful role by default

      Scenario: No role selected
        Then the system should display "Please select a role."

      Scenario: Empty phone number
        Then the system should display "This field is required."

      Scenario: Empty password
        Then the system should display "This field is required."

      Scenario: Unregistered phone number
        Then the system should display "Incorrect phone number or password."

      Scenario: Incorrect password
        Then the system should display "Incorrect phone number or password."
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US04.md"
  And The file should contain at least "9" Test Cases (TC)

################################################################################

@uc_us04 @uml
Scenario: UC-US04 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: User Login (UC-US04)

      Background:
        Given the user is on the login screen

      Scenario: Successful login
        When the user selects a role
        And enters a registered phone number
        And enters the correct password
        And clicks the "Login" button
        Then the system authenticates the user
        And redirects the user to the home screen

      Scenario: Login validation failure
        When the user submits invalid login information
        Then the system rejects the login
        And displays the appropriate validation message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US04_Sequence.txt"
  And The file should contain valid PlantUML code
  ################################################################################
# UC-US05 – Forgot Password / Password Reset
################################################################################

@uc_us05 @requirement
Scenario: UC-US05 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Forgot Password (UC-US05)
      As a user
      I want to securely reset my password
      So that I can regain access to my account

      Background:
        Given the user is on the login screen

      # Basic Flow
      Scenario: Successful password reset
        When the user clicks the "Forgot Password" link
        And enters a registered phone number
        Then the system should send an SMS verification code

        When the user enters a valid verification code
        Then the system should display the "Create New Password" screen

        When the user enters a valid new password
        And confirms the same password
        Then the system should update the password
        And display "Şifreniz başarıyla güncellenmiştir."
        And redirect the user to the login screen

      # Exception Flow 1
      Scenario: Phone number is not registered
        When the user enters an unregistered phone number
        Then the system should prevent the password reset process
        And display "Bu telefon numarası ile kayıtlı bir hesap bulunamadı."

      # Exception Flow 2
      Scenario: Password confirmation does not match
        When the user enters different values for the new password and password confirmation
        Then the system should prevent password update
        And display "Şifreler eşleşmemektedir."

      # Business Rule Validation
      Scenario: Password cannot be reset before SMS verification
        When the user has not successfully completed SMS verification
        Then the system should not display the new password screen
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-US05.md"
  And The file should contain at least "6" Functional Requirements (FR)

################################################################################

@uc_us05 @testcase
Scenario: UC-US05 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Forgot Password (UC-US05)

      Scenario: Open Forgot Password page
        Then the system should display the phone number input screen

      Scenario: Registered phone number
        Then the system should send an SMS verification code

      Scenario: Unregistered phone number
        Then the system should display "Bu telefon numarası ile kayıtlı bir hesap bulunamadı."

      Scenario: Successful SMS verification
        Then the system should display the new password screen

      Scenario: Password mismatch
        Then the system should display "Şifreler eşleşmemektedir."

      Scenario: Successful password update
        Then the system should display "Şifreniz başarıyla güncellenmiştir."
        And redirect the user to the login screen
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-US05.md"
  And The file should contain at least "6" Test Cases (TC)

################################################################################

@uc_us05 @uml
Scenario: UC-US05 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Forgot Password (UC-US05)

      Background:
        Given the user is on the login screen

      Scenario: Successful password reset
        When the user requests password reset
        And completes SMS verification
        And enters a new password
        Then the system updates the password
        And redirects the user to the login screen

      Scenario: Password reset validation failure
        When the user submits invalid password reset information
        Then the system rejects the request
        And displays the appropriate validation message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-US05_Sequence.txt"
  And The file should contain valid PlantUML code