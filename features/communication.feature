@communication
Feature: Communication Module Full AI Analysis (UC-C1 → UC-C6)

################################################################################
# UC-C1 – Dashboard UI Request Processing
################################################################################

@uc_c1 @requirement
Scenario: UC-C1 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Dashboard UI Request Processing (UC-C1)
      As the Dashboard System
      I want to fetch data from the Backend via secure API
      So that I can display reports and configurations to the Admin
      
      Background:
        Given a secure HTTPS connection exists between Dashboard and Backend
        
      # Basic Flow: Başarılı Veri Çekme
      Scenario: Dashboard successfully retrieves report data
        When the Admin triggers a "Fetch Financial Report" request
        Then the Dashboard should send a valid GET request to the Backend API
        And the Backend should validate the authorization token
        And return the data in "JSON" format with status code "200 OK"
        And the Dashboard should render the data on the UI
        
      # Alternatif Akış A1: Cache Mekanizması
      Scenario: Retreiving configuration from Cache
        When the Dashboard requests static configuration data
        Then the Backend should serve the response directly from the "Cache"
        And the response time should be significantly lower than a database query
        
      # İstisna Akış I1: Timeout (Zaman Aşımı)
      Scenario: Backend fails to respond within time limit
        When the Dashboard sends a request
        But the Backend does not respond within "2 seconds"
        Then the Dashboard should cancel the request
        And display a "System not responding" error message to the user
        
      # İstisna Akış I2: Yetkisiz Erişim (401)
      Scenario: Handling unauthorized API responses
        When the Dashboard sends a request with an invalid or expired token
        Then the Backend should return a "401 Unauthorized" status code
        And the Dashboard should redirect the user to the login screen
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-C1.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_c1 @testcase
Scenario: UC-C1 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Dashboard UI Request Processing (UC-C1)
      As the Dashboard System
      I want to fetch data from the Backend via secure API
      So that I can display reports and configurations to the Admin
      
      Background:
        Given a secure HTTPS connection exists between Dashboard and Backend
        
      # Basic Flow: Başarılı Veri Çekme
      Scenario: Dashboard successfully retrieves report data
        When the Admin triggers a "Fetch Financial Report" request
        Then the Dashboard should send a valid GET request to the Backend API
        And the Backend should validate the authorization token
        And return the data in "JSON" format with status code "200 OK"
        And the Dashboard should render the data on the UI
        
      # Alternatif Akış A1: Cache Mekanizması
      Scenario: Retreiving configuration from Cache
        When the Dashboard requests static configuration data
        Then the Backend should serve the response directly from the "Cache"
        And the response time should be significantly lower than a database query
        
      # İstisna Akış I1: Timeout (Zaman Aşımı)
      Scenario: Backend fails to respond within time limit
        When the Dashboard sends a request
        But the Backend does not respond within "2 seconds"
        Then the Dashboard should cancel the request
        And display a "System not responding" error message to the user
        
      # İstisna Akış I2: Yetkisiz Erişim (401)
      Scenario: Handling unauthorized API responses
        When the Dashboard sends a request with an invalid or expired token
        Then the Backend should return a "401 Unauthorized" status code
        And the Dashboard should redirect the user to the login screen
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-C1.md"
  And The file should contain at least "1" Test Cases (TC)

@uc_c1 @uml
Scenario: UC-C1 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Dashboard UI Request Processing (UC-C1)
      As the Dashboard System
      I want to fetch data from the Backend via secure API
      So that I can display reports and configurations to the Admin
      
      Background:
        Given a secure HTTPS connection exists between Dashboard and Backend
        
      # Basic Flow: Başarılı Veri Çekme
      Scenario: Dashboard successfully retrieves report data
        When the Admin triggers a "Fetch Financial Report" request
        Then the Dashboard should send a valid GET request to the Backend API
        And the Backend should validate the authorization token
        And return the data in "JSON" format with status code "200 OK"
        And the Dashboard should render the data on the UI
        
      # Alternatif Akış A1: Cache Mekanizması
      Scenario: Retreiving configuration from Cache
        When the Dashboard requests static configuration data
        Then the Backend should serve the response directly from the "Cache"
        And the response time should be significantly lower than a database query
        
      # İstisna Akış I1: Timeout (Zaman Aşımı)
      Scenario: Backend fails to respond within time limit
        When the Dashboard sends a request
        But the Backend does not respond within "2 seconds"
        Then the Dashboard should cancel the request
        And display a "System not responding" error message to the user
        
      # İstisna Akış I2: Yetkisiz Erişim (401)
      Scenario: Handling unauthorized API responses
        When the Dashboard sends a request with an invalid or expired token
        Then the Backend should return a "401 Unauthorized" status code
        And the Dashboard should redirect the user to the login screen
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-C1_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-C2 – Kiosk Real-time Request Processing
################################################################################

@uc_c2 @requirement
Scenario: UC-C2 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Kiosk Real-time Request Processing (UC-C2)
      As the KioskClient
      I want to get immediate responses for user actions
      So that the user experience remains fluid and responsive
      
      Background:
        Given the KioskClient has an active low-latency connection to Backend
        
      # Basic Flow: Düşük Gecikmeli Onay
      Scenario: Successful real-time permission check
        When the User scans a card/QR
        And the KioskClient sends a validation request to the Backend
        Then the Backend should verify the balance and permissions
        And respond with "Access Granted" within "500 milliseconds"
        And the KioskClient should activate the game session
        
      # Alternatif Akış A1: Yetersiz Bakiye
      Scenario: Backend denies request due to insufficient funds
        When the KioskClient requests a session start
        But the user wallet has insufficient funds
        Then the Backend should respond with "Insufficient Balance"
        And the KioskClient should display a "Please Top-up" message
        
      # İstisna Akış I2: Bağlantı Kopması ve Fallback
      Scenario: Connection loss triggers offline mode
        When the KioskClient attempts to send a request
        But detects that the connection to the Backend is lost
        Then the KioskClient should immediately switch to "Offline Communication Strategy" (UC-C5)
        And log the connection failure
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-C2.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_c2 @testcase
Scenario: UC-C2 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Kiosk Real-time Request Processing (UC-C2)
      As the KioskClient
      I want to get immediate responses for user actions
      So that the user experience remains fluid and responsive
      
      Background:
        Given the KioskClient has an active low-latency connection to Backend
        
      # Basic Flow: Düşük Gecikmeli Onay
      Scenario: Successful real-time permission check
        When the User scans a card/QR
        And the KioskClient sends a validation request to the Backend
        Then the Backend should verify the balance and permissions
        And respond with "Access Granted" within "500 milliseconds"
        And the KioskClient should activate the game session
        
      # Alternatif Akış A1: Yetersiz Bakiye
      Scenario: Backend denies request due to insufficient funds
        When the KioskClient requests a session start
        But the user wallet has insufficient funds
        Then the Backend should respond with "Insufficient Balance"
        And the KioskClient should display a "Please Top-up" message
        
      # İstisna Akış I2: Bağlantı Kopması ve Fallback
      Scenario: Connection loss triggers offline mode
        When the KioskClient attempts to send a request
        But detects that the connection to the Backend is lost
        Then the KioskClient should immediately switch to "Offline Communication Strategy" (UC-C5)
        And log the connection failure
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-C2.md"
  And The file should contain at least "1" Test Cases (TC)

@uc_c2 @uml
Scenario: UC-C2 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Kiosk Real-time Request Processing (UC-C2)
      As the KioskClient
      I want to get immediate responses for user actions
      So that the user experience remains fluid and responsive
      
      Background:
        Given the KioskClient has an active low-latency connection to Backend
        
      # Basic Flow: Düşük Gecikmeli Onay
      Scenario: Successful real-time permission check
        When the User scans a card/QR
        And the KioskClient sends a validation request to the Backend
        Then the Backend should verify the balance and permissions
        And respond with "Access Granted" within "500 milliseconds"
        And the KioskClient should activate the game session
        
      # Alternatif Akış A1: Yetersiz Bakiye
      Scenario: Backend denies request due to insufficient funds
        When the KioskClient requests a session start
        But the user wallet has insufficient funds
        Then the Backend should respond with "Insufficient Balance"
        And the KioskClient should display a "Please Top-up" message
        
      # İstisna Akış I2: Bağlantı Kopması ve Fallback
      Scenario: Connection loss triggers offline mode
        When the KioskClient attempts to send a request
        But detects that the connection to the Backend is lost
        Then the KioskClient should immediately switch to "Offline Communication Strategy" (UC-C5)
        And log the connection failure
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-C2_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-C3 – Configuration Distribution via Message Queue
################################################################################

@uc_c3 @requirement
Scenario: UC-C3 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Distribution via Message Queue (UC-C3)
      As the Backend System
      I want to distribute setting changes to all clients asynchronously
      So that configuration is consistent across the facility
      
      # Basic Flow: Başarılı Dağıtım
      Scenario: Distribute new pricing configuration
        Given the Admin has saved new game prices
        When the Backend publishes the config message to the "Message Queue"
        Then the "KioskClient" and "GameClient" should consume the message
        And apply the new prices locally
        And send an "Update Successful" acknowledgement to the Backend
        
      # Alternatif Akış A1: Client Çevrimdışı (Persistence)
      Scenario: Message persistence for offline clients
        Given the "KioskClient-05" is currently offline
        When the Backend publishes a new configuration message
        Then the Message Queue should retain the message for "KioskClient-05"
        And deliver the message immediately when "KioskClient-05" comes online
        
      # İstisna Akış I1: Kural İhlali (Client Reddi)
      Scenario: Client rejects invalid configuration
        When the Client receives a configuration that violates local rules
        Then the Client should reject the update
        And log a "Configuration Validation Error"
        And continue running with the previous valid settings
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-C3.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_c3 @testcase
Scenario: UC-C3 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Distribution via Message Queue (UC-C3)
      As the Backend System
      I want to distribute setting changes to all clients asynchronously
      So that configuration is consistent across the facility
      
      # Basic Flow: Başarılı Dağıtım
      Scenario: Distribute new pricing configuration
        Given the Admin has saved new game prices
        When the Backend publishes the config message to the "Message Queue"
        Then the "KioskClient" and "GameClient" should consume the message
        And apply the new prices locally
        And send an "Update Successful" acknowledgement to the Backend
        
      # Alternatif Akış A1: Client Çevrimdışı (Persistence)
      Scenario: Message persistence for offline clients
        Given the "KioskClient-05" is currently offline
        When the Backend publishes a new configuration message
        Then the Message Queue should retain the message for "KioskClient-05"
        And deliver the message immediately when "KioskClient-05" comes online
        
      # İstisna Akış I1: Kural İhlali (Client Reddi)
      Scenario: Client rejects invalid configuration
        When the Client receives a configuration that violates local rules
        Then the Client should reject the update
        And log a "Configuration Validation Error"
        And continue running with the previous valid settings
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-C3.md"
  And The file should contain at least "1" Test Cases (TC)

@uc_c3 @uml
Scenario: UC-C3 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Distribution via Message Queue (UC-C3)
      As the Backend System
      I want to distribute setting changes to all clients asynchronously
      So that configuration is consistent across the facility
      
      # Basic Flow: Başarılı Dağıtım
      Scenario: Distribute new pricing configuration
        Given the Admin has saved new game prices
        When the Backend publishes the config message to the "Message Queue"
        Then the "KioskClient" and "GameClient" should consume the message
        And apply the new prices locally
        And send an "Update Successful" acknowledgement to the Backend
        
      # Alternatif Akış A1: Client Çevrimdışı (Persistence)
      Scenario: Message persistence for offline clients
        Given the "KioskClient-05" is currently offline
        When the Backend publishes a new configuration message
        Then the Message Queue should retain the message for "KioskClient-05"
        And deliver the message immediately when "KioskClient-05" comes online
        
      # İstisna Akış I1: Kural İhlali (Client Reddi)
      Scenario: Client rejects invalid configuration
        When the Client receives a configuration that violates local rules
        Then the Client should reject the update
        And log a "Configuration Validation Error"
        And continue running with the previous valid settings
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-C3_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-C4 – Real-time Health Monitoring
################################################################################

@uc_c4 @requirement
Scenario: UC-C4 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Health Monitoring (UC-C4)
      As the SystemController
      I want to receive heartbeats from clients
      So that I can monitor the operational status of the facility
      
      # Basic Flow: Sağlıklı Nabız
      Scenario: System updates status based on heartbeats
        When the "KioskClient" sends a "Heartbeat" signal every "10 seconds"
        Then the SystemController should mark the client status as "Active"
        And the Dashboard should display a "Green Light" indicator
        
      # İstisna Akış I1: Nabız Kesintisi
      Scenario: Missing heartbeats trigger passive status
        Given the "GameClient-02" is currently "Active"
        When the SystemController misses "3" consecutive heartbeats from "GameClient-02"
        Then the SystemController should update the status to "Connection Lost/Passive"
        And the Dashboard should update the indicator to "Red"
        
      # İstisna Akış I2: Kritik Alarm
      Scenario: Prolonged downtime triggers alarm
        Given a client has been "Passive" for more than "5 minutes"
        Then the SystemController should trigger a "Critical Alert"
        And send an email/SMS notification to the technical support team
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-C4.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_c4 @testcase
Scenario: UC-C4 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Health Monitoring (UC-C4)
      As the SystemController
      I want to receive heartbeats from clients
      So that I can monitor the operational status of the facility
      
      # Basic Flow: Sağlıklı Nabız
      Scenario: System updates status based on heartbeats
        When the "KioskClient" sends a "Heartbeat" signal every "10 seconds"
        Then the SystemController should mark the client status as "Active"
        And the Dashboard should display a "Green Light" indicator
        
      # İstisna Akış I1: Nabız Kesintisi
      Scenario: Missing heartbeats trigger passive status
        Given the "GameClient-02" is currently "Active"
        When the SystemController misses "3" consecutive heartbeats from "GameClient-02"
        Then the SystemController should update the status to "Connection Lost/Passive"
        And the Dashboard should update the indicator to "Red"
        
      # İstisna Akış I2: Kritik Alarm
      Scenario: Prolonged downtime triggers alarm
        Given a client has been "Passive" for more than "5 minutes"
        Then the SystemController should trigger a "Critical Alert"
        And send an email/SMS notification to the technical support team
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-C4.md"
  And The file should contain at least "1" Test Cases (TC)

@uc_c4 @uml
Scenario: UC-C4 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Health Monitoring (UC-C4)
      As the SystemController
      I want to receive heartbeats from clients
      So that I can monitor the operational status of the facility
      
      # Basic Flow: Sağlıklı Nabız
      Scenario: System updates status based on heartbeats
        When the "KioskClient" sends a "Heartbeat" signal every "10 seconds"
        Then the SystemController should mark the client status as "Active"
        And the Dashboard should display a "Green Light" indicator
        
      # İstisna Akış I1: Nabız Kesintisi
      Scenario: Missing heartbeats trigger passive status
        Given the "GameClient-02" is currently "Active"
        When the SystemController misses "3" consecutive heartbeats from "GameClient-02"
        Then the SystemController should update the status to "Connection Lost/Passive"
        And the Dashboard should update the indicator to "Red"
        
      # İstisna Akış I2: Kritik Alarm
      Scenario: Prolonged downtime triggers alarm
        Given a client has been "Passive" for more than "5 minutes"
        Then the SystemController should trigger a "Critical Alert"
        And send an email/SMS notification to the technical support team
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-C4_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-C5 – Offline Mode Communication
################################################################################

@uc_c5 @requirement
Scenario: UC-C5 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Mode Communication (UC-C5)
      As a Client Device (Kiosk/Game)
      I want to communicate with the Local Backend when internet is down
      So that I can continue serving customers without interruption
      
      Background:
        Given the global internet connection is disconnected
        And a Local Backend is available on the LAN
        
      # Basic Flow: Offline Moda Geçiş ve Hizmet
      Scenario: Switch to Local Backend for service
        When the KioskClient detects internet loss
        Then it should automatically switch to "Offline Mode"
        And route all data requests to the "Local Backend IP"
        And the Local Backend should provide data from the local database
        And the service should continue seamlessly
        
      # İstisna Akış I1: Yerel Ağ Hatası
      Scenario: LAN failure during offline mode
        Given the system is in "Offline Mode"
        When the connection to the Local Backend is lost
        Then the KioskClient should display a "Service Unavailable - Network Error" screen
        And stop accepting user requests
        
      # İstisna Akış I2: Kısıtlı Hizmet
      Scenario: Requesting unsupported features in offline mode
        When the user requests a "Global Leaderboard" service
        But the system is in "Offline Mode"
        Then the system should deny the request
        And display a "Feature not available offline" message
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-C5.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_c5 @testcase
Scenario: UC-C5 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Mode Communication (UC-C5)
      As a Client Device (Kiosk/Game)
      I want to communicate with the Local Backend when internet is down
      So that I can continue serving customers without interruption
      
      Background:
        Given the global internet connection is disconnected
        And a Local Backend is available on the LAN
        
      # Basic Flow: Offline Moda Geçiş ve Hizmet
      Scenario: Switch to Local Backend for service
        When the KioskClient detects internet loss
        Then it should automatically switch to "Offline Mode"
        And route all data requests to the "Local Backend IP"
        And the Local Backend should provide data from the local database
        And the service should continue seamlessly
        
      # İstisna Akış I1: Yerel Ağ Hatası
      Scenario: LAN failure during offline mode
        Given the system is in "Offline Mode"
        When the connection to the Local Backend is lost
        Then the KioskClient should display a "Service Unavailable - Network Error" screen
        And stop accepting user requests
        
      # İstisna Akış I2: Kısıtlı Hizmet
      Scenario: Requesting unsupported features in offline mode
        When the user requests a "Global Leaderboard" service
        But the system is in "Offline Mode"
        Then the system should deny the request
        And display a "Feature not available offline" message
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-C5.md"
  And The file should contain at least "1" Test Cases (TC)

@uc_c5 @uml
Scenario: UC-C5 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Mode Communication (UC-C5)
      As a Client Device (Kiosk/Game)
      I want to communicate with the Local Backend when internet is down
      So that I can continue serving customers without interruption
      
      Background:
        Given the global internet connection is disconnected
        And a Local Backend is available on the LAN
        
      # Basic Flow: Offline Moda Geçiş ve Hizmet
      Scenario: Switch to Local Backend for service
        When the KioskClient detects internet loss
        Then it should automatically switch to "Offline Mode"
        And route all data requests to the "Local Backend IP"
        And the Local Backend should provide data from the local database
        And the service should continue seamlessly
        
      # İstisna Akış I1: Yerel Ağ Hatası
      Scenario: LAN failure during offline mode
        Given the system is in "Offline Mode"
        When the connection to the Local Backend is lost
        Then the KioskClient should display a "Service Unavailable - Network Error" screen
        And stop accepting user requests
        
      # İstisna Akış I2: Kısıtlı Hizmet
      Scenario: Requesting unsupported features in offline mode
        When the user requests a "Global Leaderboard" service
        But the system is in "Offline Mode"
        Then the system should deny the request
        And display a "Feature not available offline" message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-C5_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-C6 – Cloud Data Synchronization
################################################################################

@uc_c6 @requirement
Scenario: UC-C6 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Cloud Data Synchronization (UC-C6)
      As the Local Backend
      I want to sync stored offline data to the Cloud
      So that the central database is up-to-date
      
      Background:
        Given the internet connection has been restored
        And there are "Offline Transactions" stored locally
        
      # Basic Flow: Başarılı Senkronizasyon
      Scenario: Bulk upload of offline data
        When the Local Backend initiates the synchronization process
        And sends the transaction batch to the Cloud Database API
        Then the Cloud Database should validate and process the records
        And return a "Sync Confirmation" (ACK)
        And the Local Backend should delete the synchronized records from local storage
        
      # İstisna Akış I1: Bağlantı Tekrar Kesilirse
      Scenario: Interrupted synchronization
        When the sync process is in progress
        But the internet connection drops again
        Then the Local Backend should pause the transfer
        And retain the remaining records for the next attempt
        
      # İstisna Akış I2: Veri Çakışması (Conflict)
      Scenario: Handling data conflicts during sync
        When a local record conflicts with a newer cloud record
        Then the Cloud Database should apply the "Conflict Resolution Rule" (e.g., Keep Latest)
        And inform the Local Backend of the outcome
        And the Local Backend should mark the record as processed
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-C6.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_c6 @testcase
Scenario: UC-C6 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Cloud Data Synchronization (UC-C6)
      As the Local Backend
      I want to sync stored offline data to the Cloud
      So that the central database is up-to-date
      
      Background:
        Given the internet connection has been restored
        And there are "Offline Transactions" stored locally
        
      # Basic Flow: Başarılı Senkronizasyon
      Scenario: Bulk upload of offline data
        When the Local Backend initiates the synchronization process
        And sends the transaction batch to the Cloud Database API
        Then the Cloud Database should validate and process the records
        And return a "Sync Confirmation" (ACK)
        And the Local Backend should delete the synchronized records from local storage
        
      # İstisna Akış I1: Bağlantı Tekrar Kesilirse
      Scenario: Interrupted synchronization
        When the sync process is in progress
        But the internet connection drops again
        Then the Local Backend should pause the transfer
        And retain the remaining records for the next attempt
        
      # İstisna Akış I2: Veri Çakışması (Conflict)
      Scenario: Handling data conflicts during sync
        When a local record conflicts with a newer cloud record
        Then the Cloud Database should apply the "Conflict Resolution Rule" (e.g., Keep Latest)
        And inform the Local Backend of the outcome
        And the Local Backend should mark the record as processed
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-C6.md"
  And The file should contain at least "1" Test Cases (TC)

@uc_c6 @uml
Scenario: UC-C6 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Cloud Data Synchronization (UC-C6)
      As the Local Backend
      I want to sync stored offline data to the Cloud
      So that the central database is up-to-date
      
      Background:
        Given the internet connection has been restored
        And there are "Offline Transactions" stored locally
        
      # Basic Flow: Başarılı Senkronizasyon
      Scenario: Bulk upload of offline data
        When the Local Backend initiates the synchronization process
        And sends the transaction batch to the Cloud Database API
        Then the Cloud Database should validate and process the records
        And return a "Sync Confirmation" (ACK)
        And the Local Backend should delete the synchronized records from local storage
        
      # İstisna Akış I1: Bağlantı Tekrar Kesilirse
      Scenario: Interrupted synchronization
        When the sync process is in progress
        But the internet connection drops again
        Then the Local Backend should pause the transfer
        And retain the remaining records for the next attempt
        
      # İstisna Akış I2: Veri Çakışması (Conflict)
      Scenario: Handling data conflicts during sync
        When a local record conflicts with a newer cloud record
        Then the Cloud Database should apply the "Conflict Resolution Rule" (e.g., Keep Latest)
        And inform the Local Backend of the outcome
        And the Local Backend should mark the record as processed
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-C6_Sequence.txt"
  And The file should contain valid PlantUML code
