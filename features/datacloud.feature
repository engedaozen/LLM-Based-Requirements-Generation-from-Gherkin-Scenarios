@datacloud
Feature: Data & Cloud Module Full AI Analysis (UC-VB1 → UC-VB6)

################################################################################
# UC-VB1 – Secure Data Storage
################################################################################

@uc_vb1 @requirement
Scenario: UC-VB1 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Secure Data Storage (UC-VB1)
      As the System
      I want to encrypt sensitive user data before storage
      So that user privacy and security are maintained
      
      Background:
        Given the user is on a secure data entry screen (e.g., Payment Profile)
        
      # Basic Flow: Başarılı Şifreleme ve Kayıt
      Scenario: Encrypt and save sensitive data
        When the user enters sensitive information (Credit Card, ID)
        And confirms the save operation
        Then the system should encrypt the data using the defined security protocol
        And store the encrypted string in the database
        And display a "Data saved successfully" confirmation
        
      # Alternatif Akış 3a: Şifreleme Hatası
      Scenario: Encryption failure prevents storage
        When the user confirms the save operation
        But the Encryption Module fails to process the data
        Then the system should abort the save operation
        And the data should NOT be written to the database
        And the system should display a "Security check failed, please try again" error
        
      # Alternatif Akış 2a: İptal
      Scenario: User cancels the operation
        When the user enters data but clicks "Cancel" or leaves the screen
        Then the system should discard the input
        And no data should be persisted to the storage
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-VB1.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_vb1 @testcase
Scenario: UC-VB1 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Secure Data Storage (UC-VB1)
      As the System
      I want to encrypt sensitive user data before storage
      So that user privacy and security are maintained
      
      Background:
        Given the user is on a secure data entry screen (e.g., Payment Profile)
        
      # Basic Flow: Başarılı Şifreleme ve Kayıt
      Scenario: Encrypt and save sensitive data
        When the user enters sensitive information (Credit Card, ID)
        And confirms the save operation
        Then the system should encrypt the data using the defined security protocol
        And store the encrypted string in the database
        And display a "Data saved successfully" confirmation
        
      # Alternatif Akış 3a: Şifreleme Hatası
      Scenario: Encryption failure prevents storage
        When the user confirms the save operation
        But the Encryption Module fails to process the data
        Then the system should abort the save operation
        And the data should NOT be written to the database
        And the system should display a "Security check failed, please try again" error
        
      # Alternatif Akış 2a: İptal
      Scenario: User cancels the operation
        When the user enters data but clicks "Cancel" or leaves the screen
        Then the system should discard the input
        And no data should be persisted to the storage
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-VB1.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_vb1 @uml
Scenario: UC-VB1 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Secure Data Storage (UC-VB1)
      As the System
      I want to encrypt sensitive user data before storage
      So that user privacy and security are maintained
      
      Background:
        Given the user is on a secure data entry screen (e.g., Payment Profile)
        
      # Basic Flow: Başarılı Şifreleme ve Kayıt
      Scenario: Encrypt and save sensitive data
        When the user enters sensitive information (Credit Card, ID)
        And confirms the save operation
        Then the system should encrypt the data using the defined security protocol
        And store the encrypted string in the database
        And display a "Data saved successfully" confirmation
        
      # Alternatif Akış 3a: Şifreleme Hatası
      Scenario: Encryption failure prevents storage
        When the user confirms the save operation
        But the Encryption Module fails to process the data
        Then the system should abort the save operation
        And the data should NOT be written to the database
        And the system should display a "Security check failed, please try again" error
        
      # Alternatif Akış 2a: İptal
      Scenario: User cancels the operation
        When the user enters data but clicks "Cancel" or leaves the screen
        Then the system should discard the input
        And no data should be persisted to the storage
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-VB1_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-VB2 – Offline Mode Capability
################################################################################

@uc_vb2 @requirement
Scenario: UC-VB2 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Mode Capability (UC-VB2)
      As a User
      I want to access cached content when internet is unavailable
      So that I can continue using the application
      
      Background:
        Given the application has previously cached essential data
        
      # Basic Flow: Offline Moda Geçiş ve Okuma
      Scenario: Seamless switch to offline mode
        Given the internet connection is lost
        When the system detects the disconnection
        Then it should automatically switch to "Offline Mode"
        And serve data requests from the "Local Cache"
        And queue any write operations for later synchronization
        
      # Alternatif Akış 3a: Desteklenmeyen İşlem
      Scenario: Attempting online-only actions while offline
        Given the system is in "Offline Mode"
        When the user attempts to "Download New Content"
        Then the system should block the request
        And display a "Internet connection required" warning
        
      # İstisna Akış 5a: Senkronizasyon Hatası
      Scenario: Sync failure after reconnection
        Given the connection is restored
        When the system attempts to sync offline data
        But the synchronization process encounters an error
        Then the system should display a "Sync failed, please retry later" message
        And keep the data in the local queue
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-VB2.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_vb2 @testcase
Scenario: UC-VB2 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Mode Capability (UC-VB2)
      As a User
      I want to access cached content when internet is unavailable
      So that I can continue using the application
      
      Background:
        Given the application has previously cached essential data
        
      # Basic Flow: Offline Moda Geçiş ve Okuma
      Scenario: Seamless switch to offline mode
        Given the internet connection is lost
        When the system detects the disconnection
        Then it should automatically switch to "Offline Mode"
        And serve data requests from the "Local Cache"
        And queue any write operations for later synchronization
        
      # Alternatif Akış 3a: Desteklenmeyen İşlem
      Scenario: Attempting online-only actions while offline
        Given the system is in "Offline Mode"
        When the user attempts to "Download New Content"
        Then the system should block the request
        And display a "Internet connection required" warning
        
      # İstisna Akış 5a: Senkronizasyon Hatası
      Scenario: Sync failure after reconnection
        Given the connection is restored
        When the system attempts to sync offline data
        But the synchronization process encounters an error
        Then the system should display a "Sync failed, please retry later" message
        And keep the data in the local queue
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-VB2.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_vb2 @uml
Scenario: UC-VB2 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Mode Capability (UC-VB2)
      As a User
      I want to access cached content when internet is unavailable
      So that I can continue using the application
      
      Background:
        Given the application has previously cached essential data
        
      # Basic Flow: Offline Moda Geçiş ve Okuma
      Scenario: Seamless switch to offline mode
        Given the internet connection is lost
        When the system detects the disconnection
        Then it should automatically switch to "Offline Mode"
        And serve data requests from the "Local Cache"
        And queue any write operations for later synchronization
        
      # Alternatif Akış 3a: Desteklenmeyen İşlem
      Scenario: Attempting online-only actions while offline
        Given the system is in "Offline Mode"
        When the user attempts to "Download New Content"
        Then the system should block the request
        And display a "Internet connection required" warning
        
      # İstisna Akış 5a: Senkronizasyon Hatası
      Scenario: Sync failure after reconnection
        Given the connection is restored
        When the system attempts to sync offline data
        But the synchronization process encounters an error
        Then the system should display a "Sync failed, please retry later" message
        And keep the data in the local queue
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-VB2_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-VB3 – Central Configuration Management
################################################################################

@uc_vb3 @requirement
Scenario: UC-VB3 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Central Configuration Management (UC-VB3)
      As a System Administrator
      I want to update settings from a central dashboard
      So that configuration is consistent across all units
      
      Background:
        Given the Admin is logged into the Central Management Console
        
      # Basic Flow: Ayarların Dağıtılması
      Scenario: Update and propagate global settings
        When the Admin updates the "Security Level" setting to "High"
        And saves the changes
        Then the system should save the new value centrally
        And trigger a synchronization job to all connected units
        And confirm "Update successful" to the Admin
        
      # Alternatif Akış 3a: Geçersiz Veri Girişi
      Scenario: Validation of configuration values
        When the Admin enters text "ABC" into a numeric field "Timeout Duration"
        Then the system should reject the input
        And display a "Invalid format" validation error
        
      # İstisna Akış 5a: Kısmi Senkronizasyon Hatası
      Scenario: Handling sync failures on specific units
        When the system propagates the changes
        But the synchronization fails for "Unit-A" and "Unit-B"
        Then the system should report these failures to the Admin
        And provide detailed error logs for the affected units
        And allow manual retry for the failed units
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-VB3.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_vb3 @testcase
Scenario: UC-VB3 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Central Configuration Management (UC-VB3)
      As a System Administrator
      I want to update settings from a central dashboard
      So that configuration is consistent across all units
      
      Background:
        Given the Admin is logged into the Central Management Console
        
      # Basic Flow: Ayarların Dağıtılması
      Scenario: Update and propagate global settings
        When the Admin updates the "Security Level" setting to "High"
        And saves the changes
        Then the system should save the new value centrally
        And trigger a synchronization job to all connected units
        And confirm "Update successful" to the Admin
        
      # Alternatif Akış 3a: Geçersiz Veri Girişi
      Scenario: Validation of configuration values
        When the Admin enters text "ABC" into a numeric field "Timeout Duration"
        Then the system should reject the input
        And display a "Invalid format" validation error
        
      # İstisna Akış 5a: Kısmi Senkronizasyon Hatası
      Scenario: Handling sync failures on specific units
        When the system propagates the changes
        But the synchronization fails for "Unit-A" and "Unit-B"
        Then the system should report these failures to the Admin
        And provide detailed error logs for the affected units
        And allow manual retry for the failed units
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-VB3.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_vb3 @uml
Scenario: UC-VB3 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Central Configuration Management (UC-VB3)
      As a System Administrator
      I want to update settings from a central dashboard
      So that configuration is consistent across all units
      
      Background:
        Given the Admin is logged into the Central Management Console
        
      # Basic Flow: Ayarların Dağıtılması
      Scenario: Update and propagate global settings
        When the Admin updates the "Security Level" setting to "High"
        And saves the changes
        Then the system should save the new value centrally
        And trigger a synchronization job to all connected units
        And confirm "Update successful" to the Admin
        
      # Alternatif Akış 3a: Geçersiz Veri Girişi
      Scenario: Validation of configuration values
        When the Admin enters text "ABC" into a numeric field "Timeout Duration"
        Then the system should reject the input
        And display a "Invalid format" validation error
        
      # İstisna Akış 5a: Kısmi Senkronizasyon Hatası
      Scenario: Handling sync failures on specific units
        When the system propagates the changes
        But the synchronization fails for "Unit-A" and "Unit-B"
        Then the system should report these failures to the Admin
        And provide detailed error logs for the affected units
        And allow manual retry for the failed units
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-VB3_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-VB4 – Row-Based Data Retrieval
################################################################################

@uc_vb4 @requirement
Scenario: UC-VB4 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Row-Based Data Retrieval (UC-VB4)
      As the System
      I want to fetch only relevant data rows based on criteria
      So that performance is optimized and unnecessary data transfer is avoided
      
      # Basic Flow: Kriterli Veri Çekme
      Scenario Outline: Fetch data matching specific criteria
        When the system requests data with criteria "<criteria>"
        Then the system should execute a query against the Data Source
        And the result set should only contain rows matching "<criteria>"
        And the data should be displayed on the UI
        
        Examples:
          | criteria               |
          | Date = Today           |
          | Category = Electronics |
          | Status = Active        |
          
      # Alternatif Akış 3a: Veri Kaynağı Erişim Hatası
      Scenario: Database connection failure
        When the system attempts to query the Data Source
        But the connection is unavailable
        Then the system should log a "Data source access error"
        And display a generic error message to the user
        
      # Alternatif Akış 4a: Veri Bulunamadı
      Scenario: No data matches the criteria
        When the system queries for criteria that yield no results
        Then the system should return an empty set
        And display a "No data found matching criteria" message
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-VB4.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_vb4 @testcase
Scenario: UC-VB4 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Row-Based Data Retrieval (UC-VB4)
      As the System
      I want to fetch only relevant data rows based on criteria
      So that performance is optimized and unnecessary data transfer is avoided
      
      # Basic Flow: Kriterli Veri Çekme
      Scenario Outline: Fetch data matching specific criteria
        When the system requests data with criteria "<criteria>"
        Then the system should execute a query against the Data Source
        And the result set should only contain rows matching "<criteria>"
        And the data should be displayed on the UI
        
        Examples:
          | criteria               |
          | Date = Today           |
          | Category = Electronics |
          | Status = Active        |
          
      # Alternatif Akış 3a: Veri Kaynağı Erişim Hatası
      Scenario: Database connection failure
        When the system attempts to query the Data Source
        But the connection is unavailable
        Then the system should log a "Data source access error"
        And display a generic error message to the user
        
      # Alternatif Akış 4a: Veri Bulunamadı
      Scenario: No data matches the criteria
        When the system queries for criteria that yield no results
        Then the system should return an empty set
        And display a "No data found matching criteria" message
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-VB4.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_vb4 @uml
Scenario: UC-VB4 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Row-Based Data Retrieval (UC-VB4)
      As the System
      I want to fetch only relevant data rows based on criteria
      So that performance is optimized and unnecessary data transfer is avoided
      
      # Basic Flow: Kriterli Veri Çekme
      Scenario Outline: Fetch data matching specific criteria
        When the system requests data with criteria "<criteria>"
        Then the system should execute a query against the Data Source
        And the result set should only contain rows matching "<criteria>"
        And the data should be displayed on the UI
        
        Examples:
          | criteria               |
          | Date = Today           |
          | Category = Electronics |
          | Status = Active        |
          
      # Alternatif Akış 3a: Veri Kaynağı Erişim Hatası
      Scenario: Database connection failure
        When the system attempts to query the Data Source
        But the connection is unavailable
        Then the system should log a "Data source access error"
        And display a generic error message to the user
        
      # Alternatif Akış 4a: Veri Bulunamadı
      Scenario: No data matches the criteria
        When the system queries for criteria that yield no results
        Then the system should return an empty set
        And display a "No data found matching criteria" message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-VB4_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-VB5 – Downstream Data Updates
################################################################################

@uc_vb5 @requirement
Scenario: UC-VB5 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Downstream Data Updates (UC-VB5)
      As a System Unit (Store/Kiosk)
      I want to receive updates from the Central System
      So that my local data (products, campaigns) is up-to-date
      
      # Basic Flow: Güncelleme Paketini İşleme
      Scenario: Successfully receive and apply update package
        Given the Central System has released a new "Campaign Update"
        When the System Unit receives the update package
        Then it should parse and apply the data to its local database
        And send an "Update Completed" acknowledgement to the Central System
        
      # Alternatif Akış 3a: Paket İndirme Hatası
      Scenario: Network failure during package download
        When the System Unit attempts to download the update package
        But the download is interrupted or fails
        Then the system should trigger a "Retry Mechanism"
        And log the network error
        
      # İstisna Akış 4a: Bozuk Veri Paketi
      Scenario: Handling corrupted update data
        When the System Unit receives the data
        But detects a format error or inconsistency during processing
        Then it should quarantine the corrupted data
        And log a "Data Integrity Error"
        And notify the Central System of the failure
        And continue operating with valid existing data
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-VB5.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_vb5 @testcase
Scenario: UC-VB5 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Downstream Data Updates (UC-VB5)
      As a System Unit (Store/Kiosk)
      I want to receive updates from the Central System
      So that my local data (products, campaigns) is up-to-date
      
      # Basic Flow: Güncelleme Paketini İşleme
      Scenario: Successfully receive and apply update package
        Given the Central System has released a new "Campaign Update"
        When the System Unit receives the update package
        Then it should parse and apply the data to its local database
        And send an "Update Completed" acknowledgement to the Central System
        
      # Alternatif Akış 3a: Paket İndirme Hatası
      Scenario: Network failure during package download
        When the System Unit attempts to download the update package
        But the download is interrupted or fails
        Then the system should trigger a "Retry Mechanism"
        And log the network error
        
      # İstisna Akış 4a: Bozuk Veri Paketi
      Scenario: Handling corrupted update data
        When the System Unit receives the data
        But detects a format error or inconsistency during processing
        Then it should quarantine the corrupted data
        And log a "Data Integrity Error"
        And notify the Central System of the failure
        And continue operating with valid existing data
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-VB5.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_vb5 @uml
Scenario: UC-VB5 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Downstream Data Updates (UC-VB5)
      As a System Unit (Store/Kiosk)
      I want to receive updates from the Central System
      So that my local data (products, campaigns) is up-to-date
      
      # Basic Flow: Güncelleme Paketini İşleme
      Scenario: Successfully receive and apply update package
        Given the Central System has released a new "Campaign Update"
        When the System Unit receives the update package
        Then it should parse and apply the data to its local database
        And send an "Update Completed" acknowledgement to the Central System
        
      # Alternatif Akış 3a: Paket İndirme Hatası
      Scenario: Network failure during package download
        When the System Unit attempts to download the update package
        But the download is interrupted or fails
        Then the system should trigger a "Retry Mechanism"
        And log the network error
        
      # İstisna Akış 4a: Bozuk Veri Paketi
      Scenario: Handling corrupted update data
        When the System Unit receives the data
        But detects a format error or inconsistency during processing
        Then it should quarantine the corrupted data
        And log a "Data Integrity Error"
        And notify the Central System of the failure
        And continue operating with valid existing data
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-VB5_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-VB6 – Bi-Directional Data Synchronization
################################################################################

@uc_vb6 @requirement
Scenario: UC-VB6 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Bi-Directional Data Synchronization (UC-VB6)
      As the System
      I want to sync data between Local and Cloud environments
      So that data consistency is maintained across the hybrid architecture
      
      Background:
        Given a connection exists between Local and Cloud systems
        
      # Basic Flow: İki Yönlü Eşitleme
      Scenario: Sync changes from both directions
        When a record is modified in the "Local System"
        And a different record is modified in the "Cloud System"
        Then the Sync Engine should detect both changes
        And update the Cloud with the local change
        And update the Local System with the cloud change
        And mark both records as "Synced"
        
      # Alternatif Akış 3a: Veri Çakışması (Conflict Resolution)
      Scenario: Handling concurrent updates on the same data
        Given a specific record is edited locally AND in the cloud simultaneously
        When the synchronization process runs
        Then the system should identify a "Data Conflict"
        And apply the predefined rule (e.g., "Last Write Wins" or "Cloud Wins")
        And log the resolution action
        And notify the Admin if manual intervention is required
        
      # İstisna Akış 4a: Güvenlik İhlali
      Scenario: Detecting unauthorized data manipulation during sync
        When the system detects a suspicious data signature during sync
        Then it should immediately abort the synchronization
        And raise a "Security Alert" to the Admin
        And block the compromised data packet
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-VB6.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_vb6 @testcase
Scenario: UC-VB6 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Bi-Directional Data Synchronization (UC-VB6)
      As the System
      I want to sync data between Local and Cloud environments
      So that data consistency is maintained across the hybrid architecture
      
      Background:
        Given a connection exists between Local and Cloud systems
        
      # Basic Flow: İki Yönlü Eşitleme
      Scenario: Sync changes from both directions
        When a record is modified in the "Local System"
        And a different record is modified in the "Cloud System"
        Then the Sync Engine should detect both changes
        And update the Cloud with the local change
        And update the Local System with the cloud change
        And mark both records as "Synced"
        
      # Alternatif Akış 3a: Veri Çakışması (Conflict Resolution)
      Scenario: Handling concurrent updates on the same data
        Given a specific record is edited locally AND in the cloud simultaneously
        When the synchronization process runs
        Then the system should identify a "Data Conflict"
        And apply the predefined rule (e.g., "Last Write Wins" or "Cloud Wins")
        And log the resolution action
        And notify the Admin if manual intervention is required
        
      # İstisna Akış 4a: Güvenlik İhlali
      Scenario: Detecting unauthorized data manipulation during sync
        When the system detects a suspicious data signature during sync
        Then it should immediately abort the synchronization
        And raise a "Security Alert" to the Admin
        And block the compromised data packet
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-VB6.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_vb6 @uml
Scenario: UC-VB6 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Bi-Directional Data Synchronization (UC-VB6)
      As the System
      I want to sync data between Local and Cloud environments
      So that data consistency is maintained across the hybrid architecture
      
      Background:
        Given a connection exists between Local and Cloud systems
        
      # Basic Flow: İki Yönlü Eşitleme
      Scenario: Sync changes from both directions
        When a record is modified in the "Local System"
        And a different record is modified in the "Cloud System"
        Then the Sync Engine should detect both changes
        And update the Cloud with the local change
        And update the Local System with the cloud change
        And mark both records as "Synced"
        
      # Alternatif Akış 3a: Veri Çakışması (Conflict Resolution)
      Scenario: Handling concurrent updates on the same data
        Given a specific record is edited locally AND in the cloud simultaneously
        When the synchronization process runs
        Then the system should identify a "Data Conflict"
        And apply the predefined rule (e.g., "Last Write Wins" or "Cloud Wins")
        And log the resolution action
        And notify the Admin if manual intervention is required
        
      # İstisna Akış 4a: Güvenlik İhlali
      Scenario: Detecting unauthorized data manipulation during sync
        When the system detects a suspicious data signature during sync
        Then it should immediately abort the synchronization
        And raise a "Security Alert" to the Admin
        And block the compromised data packet
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-VB6_Sequence.txt"
  And The file should contain valid PlantUML code
