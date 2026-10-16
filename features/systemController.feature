@systemcontroller
Feature: SystemController Module Full AI Analysis (UC-SC1 → UC-SC6)

################################################################################
# UC-SC1 – System Mode Switching
################################################################################

@uc_sc1 @requirement
Scenario: UC-SC1 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: System Mode Switching (UC-SC1)
      As a System Administrator
      I want to change the operational mode of the system
      So that I can adapt the hardware for different use cases (Server, Client, Kiosk)
      
      Background:
        Given the Admin is logged into the System Settings interface
        
      # Basic Flow: Başarılı Mod Değişimi
      Scenario Outline: Successfully switch system mode
        Given the current system mode is "<current_mode>"
        When the Admin selects "<target_mode>" from the mode options
        And confirms the change
        Then the system should reconfigure the necessary services
        And restart in "<target_mode>"
        And display a "Mode switch successful" notification
        
        Examples:
          | current_mode | target_mode |
          | Server       | Kiosk       |
          | Kiosk        | Maintenance |
          
      # İstisna Akış 5a: Hata Durumunda Geri Alma (Rollback)
      Scenario: Rollback to previous mode on configuration failure
        Given the system is switching from "Server" to "Kiosk"
        When a configuration error or resource conflict occurs during the switch
        Then the system should abort the operation
        And automatically rollback to "Server" mode
        And display a "Switch failed, reverted to previous state" error message
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-SC1.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_sc1 @testcase
Scenario: UC-SC1 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: System Mode Switching (UC-SC1)
      As a System Administrator
      I want to change the operational mode of the system
      So that I can adapt the hardware for different use cases (Server, Client, Kiosk)
      
      Background:
        Given the Admin is logged into the System Settings interface
        
      # Basic Flow: Başarılı Mod Değişimi
      Scenario Outline: Successfully switch system mode
        Given the current system mode is "<current_mode>"
        When the Admin selects "<target_mode>" from the mode options
        And confirms the change
        Then the system should reconfigure the necessary services
        And restart in "<target_mode>"
        And display a "Mode switch successful" notification
        
        Examples:
          | current_mode | target_mode |
          | Server       | Kiosk       |
          | Kiosk        | Maintenance |
          
      # İstisna Akış 5a: Hata Durumunda Geri Alma (Rollback)
      Scenario: Rollback to previous mode on configuration failure
        Given the system is switching from "Server" to "Kiosk"
        When a configuration error or resource conflict occurs during the switch
        Then the system should abort the operation
        And automatically rollback to "Server" mode
        And display a "Switch failed, reverted to previous state" error message
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-SC1.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_sc1 @uml
Scenario: UC-SC1 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: System Mode Switching (UC-SC1)
      As a System Administrator
      I want to change the operational mode of the system
      So that I can adapt the hardware for different use cases (Server, Client, Kiosk)
      
      Background:
        Given the Admin is logged into the System Settings interface
        
      # Basic Flow: Başarılı Mod Değişimi
      Scenario Outline: Successfully switch system mode
        Given the current system mode is "<current_mode>"
        When the Admin selects "<target_mode>" from the mode options
        And confirms the change
        Then the system should reconfigure the necessary services
        And restart in "<target_mode>"
        And display a "Mode switch successful" notification
        
        Examples:
          | current_mode | target_mode |
          | Server       | Kiosk       |
          | Kiosk        | Maintenance |
          
      # İstisna Akış 5a: Hata Durumunda Geri Alma (Rollback)
      Scenario: Rollback to previous mode on configuration failure
        Given the system is switching from "Server" to "Kiosk"
        When a configuration error or resource conflict occurs during the switch
        Then the system should abort the operation
        And automatically rollback to "Server" mode
        And display a "Switch failed, reverted to previous state" error message
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-SC1_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-SC2 – Centralized Log Management
################################################################################

@uc_sc2 @requirement
Scenario: UC-SC2 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Centralized Log Management (UC-SC2)
      As the System
      I want to collect and store logs centrally
      So that I can analyze issues across all devices
      
      # Basic Flow: Log Oluşturma ve Gönderme
      Scenario: Device sends logs to Central Server
        When a "User Login" event occurs on "Kiosk-01"
        Then the system should generate a log entry with timestamp
        And transmit the log to the Central Log Server
        And the Central Server should store it in the database
        
      # İstisna Akış 3a: Gönderim Hatası ve Retry
      Scenario: Retry mechanism for failed log transmission
        When the system attempts to send a log
        But the connection to the Central Log Server is down
        Then the system should store the log in "Local Buffer"
        And retry sending periodically until success
        And generate a "Transmission Delayed" warning locally
        
      # Basic Flow: Log Geri Çağırma (Retrieval)
      Scenario: Admin requests logs from a specific device
        Given the Admin needs to analyze a specific issue
        When the Admin requests logs for "GameClient-05" from the Central Server
        Then the Central Server should retrieve the requested logs
        And send them back to the Admin's dashboard for viewing
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-SC2.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_sc2 @testcase
Scenario: UC-SC2 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Centralized Log Management (UC-SC2)
      As the System
      I want to collect and store logs centrally
      So that I can analyze issues across all devices
      
      # Basic Flow: Log Oluşturma ve Gönderme
      Scenario: Device sends logs to Central Server
        When a "User Login" event occurs on "Kiosk-01"
        Then the system should generate a log entry with timestamp
        And transmit the log to the Central Log Server
        And the Central Server should store it in the database
        
      # İstisna Akış 3a: Gönderim Hatası ve Retry
      Scenario: Retry mechanism for failed log transmission
        When the system attempts to send a log
        But the connection to the Central Log Server is down
        Then the system should store the log in "Local Buffer"
        And retry sending periodically until success
        And generate a "Transmission Delayed" warning locally
        
      # Basic Flow: Log Geri Çağırma (Retrieval)
      Scenario: Admin requests logs from a specific device
        Given the Admin needs to analyze a specific issue
        When the Admin requests logs for "GameClient-05" from the Central Server
        Then the Central Server should retrieve the requested logs
        And send them back to the Admin's dashboard for viewing
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-SC2.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_sc2 @uml
Scenario: UC-SC2 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Centralized Log Management (UC-SC2)
      As the System
      I want to collect and store logs centrally
      So that I can analyze issues across all devices
      
      # Basic Flow: Log Oluşturma ve Gönderme
      Scenario: Device sends logs to Central Server
        When a "User Login" event occurs on "Kiosk-01"
        Then the system should generate a log entry with timestamp
        And transmit the log to the Central Log Server
        And the Central Server should store it in the database
        
      # İstisna Akış 3a: Gönderim Hatası ve Retry
      Scenario: Retry mechanism for failed log transmission
        When the system attempts to send a log
        But the connection to the Central Log Server is down
        Then the system should store the log in "Local Buffer"
        And retry sending periodically until success
        And generate a "Transmission Delayed" warning locally
        
      # Basic Flow: Log Geri Çağırma (Retrieval)
      Scenario: Admin requests logs from a specific device
        Given the Admin needs to analyze a specific issue
        When the Admin requests logs for "GameClient-05" from the Central Server
        Then the Central Server should retrieve the requested logs
        And send them back to the Admin's dashboard for viewing
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-SC2_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-SC3 – Real-time Device and Game Monitoring
################################################################################

@uc_sc3 @requirement
Scenario: UC-SC3 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Device and Game Monitoring (UC-SC3)
      As a System Administrator
      I want to monitor the status of connected devices and running games
      So that I can ensure operational health
      
      Background:
        Given the Admin is on the "Monitoring Dashboard"
        
      # Basic Flow: Başarılı İzleme
      Scenario: Dashboard displays correct device statuses
        When the system collects status data from all connected agents
        Then the Dashboard should display a table with:
          | Device ID | Connection Status | Current Game | Health |
          | Kiosk-01  | Online            | Idle         | Good   |
          | Game-05   | Online            | Racing       | Good   |
          
      # İstisna Akış 2a: Cihazdan Veri Alınamıyor
      Scenario: Handling unreachable devices
        When the system attempts to poll status from "Kiosk-03"
        But the device does not respond
        Then the Dashboard should mark "Kiosk-03" status as "Offline" or "Unknown"
        And display a warning icon next to the device entry
        
      # İstisna Akış 3a: Tutarsız Veri
      Scenario: Handling inconsistent status data
        When the system receives malformed status data from a device
        Then the system should log a "Data Integrity Warning"
        And display the last known valid status with a timestamp indicating staleness
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-SC3.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_sc3 @testcase
Scenario: UC-SC3 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Device and Game Monitoring (UC-SC3)
      As a System Administrator
      I want to monitor the status of connected devices and running games
      So that I can ensure operational health
      
      Background:
        Given the Admin is on the "Monitoring Dashboard"
        
      # Basic Flow: Başarılı İzleme
      Scenario: Dashboard displays correct device statuses
        When the system collects status data from all connected agents
        Then the Dashboard should display a table with:
          | Device ID | Connection Status | Current Game | Health |
          | Kiosk-01  | Online            | Idle         | Good   |
          | Game-05   | Online            | Racing       | Good   |
          
      # İstisna Akış 2a: Cihazdan Veri Alınamıyor
      Scenario: Handling unreachable devices
        When the system attempts to poll status from "Kiosk-03"
        But the device does not respond
        Then the Dashboard should mark "Kiosk-03" status as "Offline" or "Unknown"
        And display a warning icon next to the device entry
        
      # İstisna Akış 3a: Tutarsız Veri
      Scenario: Handling inconsistent status data
        When the system receives malformed status data from a device
        Then the system should log a "Data Integrity Warning"
        And display the last known valid status with a timestamp indicating staleness
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-SC3.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_sc3 @uml
Scenario: UC-SC3 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Device and Game Monitoring (UC-SC3)
      As a System Administrator
      I want to monitor the status of connected devices and running games
      So that I can ensure operational health
      
      Background:
        Given the Admin is on the "Monitoring Dashboard"
        
      # Basic Flow: Başarılı İzleme
      Scenario: Dashboard displays correct device statuses
        When the system collects status data from all connected agents
        Then the Dashboard should display a table with:
          | Device ID | Connection Status | Current Game | Health |
          | Kiosk-01  | Online            | Idle         | Good   |
          | Game-05   | Online            | Racing       | Good   |
          
      # İstisna Akış 2a: Cihazdan Veri Alınamıyor
      Scenario: Handling unreachable devices
        When the system attempts to poll status from "Kiosk-03"
        But the device does not respond
        Then the Dashboard should mark "Kiosk-03" status as "Offline" or "Unknown"
        And display a warning icon next to the device entry
        
      # İstisna Akış 3a: Tutarsız Veri
      Scenario: Handling inconsistent status data
        When the system receives malformed status data from a device
        Then the system should log a "Data Integrity Warning"
        And display the last known valid status with a timestamp indicating staleness
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-SC3_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-SC4 – Remote Control Operations
################################################################################

@uc_sc4 @requirement
Scenario: UC-SC4 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Remote Control Operations (UC-SC4)
      As a System Administrator
      I want to send remote commands to devices
      So that I can manage them without physical access
      
      # Basic Flow: Uzaktan Kontrol
      Scenario Outline: Execute remote command on device
        Given the Admin selects device "<device_id>"
        When the Admin sends the "<command>" command
        Then the system should transmit the command securely
        And the device should execute the command
        And return a "<result>" message to the Admin
        
        Examples:
          | device_id | command       | result               |
          | Kiosk-01  | REBOOT        | Reboot Initiated     |
          | Game-02   | UPDATE_CONFIG | Config Applied       |
          | Kiosk-04  | SHUTDOWN      | Shutdown In Progress |
          
      # İstisna Akış 6a: Cihaz Komutu İşleyemezse
      Scenario: Device fails to execute command
        When the Admin sends a "UPDATE_SOFTWARE" command to "Kiosk-Legacy"
        But the device encounters an internal error
        Then the device should respond with "Command Execution Failed: Error Code 500"
        And the Admin should see the error detail on the dashboard
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-SC4.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_sc4 @testcase
Scenario: UC-SC4 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Remote Control Operations (UC-SC4)
      As a System Administrator
      I want to send remote commands to devices
      So that I can manage them without physical access
      
      # Basic Flow: Uzaktan Kontrol
      Scenario Outline: Execute remote command on device
        Given the Admin selects device "<device_id>"
        When the Admin sends the "<command>" command
        Then the system should transmit the command securely
        And the device should execute the command
        And return a "<result>" message to the Admin
        
        Examples:
          | device_id | command       | result               |
          | Kiosk-01  | REBOOT        | Reboot Initiated     |
          | Game-02   | UPDATE_CONFIG | Config Applied       |
          | Kiosk-04  | SHUTDOWN      | Shutdown In Progress |
          
      # İstisna Akış 6a: Cihaz Komutu İşleyemezse
      Scenario: Device fails to execute command
        When the Admin sends a "UPDATE_SOFTWARE" command to "Kiosk-Legacy"
        But the device encounters an internal error
        Then the device should respond with "Command Execution Failed: Error Code 500"
        And the Admin should see the error detail on the dashboard
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-SC4.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_sc4 @uml
Scenario: UC-SC4 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Remote Control Operations (UC-SC4)
      As a System Administrator
      I want to send remote commands to devices
      So that I can manage them without physical access
      
      # Basic Flow: Uzaktan Kontrol
      Scenario Outline: Execute remote command on device
        Given the Admin selects device "<device_id>"
        When the Admin sends the "<command>" command
        Then the system should transmit the command securely
        And the device should execute the command
        And return a "<result>" message to the Admin
        
        Examples:
          | device_id | command       | result               |
          | Kiosk-01  | REBOOT        | Reboot Initiated     |
          | Game-02   | UPDATE_CONFIG | Config Applied       |
          | Kiosk-04  | SHUTDOWN      | Shutdown In Progress |
          
      # İstisna Akış 6a: Cihaz Komutu İşleyemezse
      Scenario: Device fails to execute command
        When the Admin sends a "UPDATE_SOFTWARE" command to "Kiosk-Legacy"
        But the device encounters an internal error
        Then the device should respond with "Command Execution Failed: Error Code 500"
        And the Admin should see the error detail on the dashboard
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-SC4_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-SC5 – Central Asset Distribution
################################################################################

@uc_sc5 @requirement
Scenario: UC-SC5 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Central Asset Distribution (UC-SC5)
      As a System Administrator
      I want to deploy digital assets (games, patches) to multiple devices
      So that all units have the latest content
      
      # Basic Flow: Varlık Dağıtımı
      Scenario: Deploying a new game update to kiosks
        Given the Admin selects "Game_Update_v2.zip"
        And selects target group "All Kiosks"
        When the Admin starts the deployment
        Then the Central System should transfer the file using bandwidth optimization
        And each Kiosk should install the update upon receipt
        And report "Installation Complete" statu
        
      # İstisna Akış 4a: Bağlantı Kopması (Pause/Resume)
      Scenario: Network interruption pauses download
        Given the deployment is in progress at "50%"
        When the network connection drops for a target device
        Then the download should "Pause" automatically
        When the connection is restored
        Then the download should "Resume" from "50%" (not 0%)
        
      # İstisna Akış 5a: Yetersiz Disk Alanı
      Scenario: Installation failure due to disk space
        When the target device attempts to install the asset
        But there is insufficient disk space
        Then the device should report "Installation Failed: Disk Full"
        And the Admin dashboard should highlight the specific failure
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-SC5.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_sc5 @testcase
Scenario: UC-SC5 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Central Asset Distribution (UC-SC5)
      As a System Administrator
      I want to deploy digital assets (games, patches) to multiple devices
      So that all units have the latest content
      
      # Basic Flow: Varlık Dağıtımı
      Scenario: Deploying a new game update to kiosks
        Given the Admin selects "Game_Update_v2.zip"
        And selects target group "All Kiosks"
        When the Admin starts the deployment
        Then the Central System should transfer the file using bandwidth optimization
        And each Kiosk should install the update upon receipt
        And report "Installation Complete" statu
        
      # İstisna Akış 4a: Bağlantı Kopması (Pause/Resume)
      Scenario: Network interruption pauses download
        Given the deployment is in progress at "50%"
        When the network connection drops for a target device
        Then the download should "Pause" automatically
        When the connection is restored
        Then the download should "Resume" from "50%" (not 0%)
        
      # İstisna Akış 5a: Yetersiz Disk Alanı
      Scenario: Installation failure due to disk space
        When the target device attempts to install the asset
        But there is insufficient disk space
        Then the device should report "Installation Failed: Disk Full"
        And the Admin dashboard should highlight the specific failure
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-SC5.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_sc5 @uml
Scenario: UC-SC5 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Central Asset Distribution (UC-SC5)
      As a System Administrator
      I want to deploy digital assets (games, patches) to multiple devices
      So that all units have the latest content
      
      # Basic Flow: Varlık Dağıtımı
      Scenario: Deploying a new game update to kiosks
        Given the Admin selects "Game_Update_v2.zip"
        And selects target group "All Kiosks"
        When the Admin starts the deployment
        Then the Central System should transfer the file using bandwidth optimization
        And each Kiosk should install the update upon receipt
        And report "Installation Complete" statu
        
      # İstisna Akış 4a: Bağlantı Kopması (Pause/Resume)
      Scenario: Network interruption pauses download
        Given the deployment is in progress at "50%"
        When the network connection drops for a target device
        Then the download should "Pause" automatically
        When the connection is restored
        Then the download should "Resume" from "50%" (not 0%)
        
      # İstisna Akış 5a: Yetersiz Disk Alanı
      Scenario: Installation failure due to disk space
        When the target device attempts to install the asset
        But there is insufficient disk space
        Then the device should report "Installation Failed: Disk Full"
        And the Admin dashboard should highlight the specific failure
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-SC5_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-SC6 – Software Version Tracking
################################################################################

@uc_sc6 @requirement
Scenario: UC-SC6 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Software Version Tracking (UC-SC6)
      As a System Administrator
      I want to view software versions across the fleet
      So that I can identify outdated or non-compliant devices
      
      # Basic Flow: Sürüm Listeleme
      Scenario: Displaying version inventory
        When the Admin navigates to "Version Control"
        Then the system should list all devices with their software versions:
          | Device Name | OS Version | App Version | Status     |
          | Kiosk-01    | Win10      | v2.1.0      | Up-to-date |
          | Kiosk-02    | Win10      | v2.0.9      | Outdated   |
          
      # İstisna Akış 2a: Bilinmeyen Sürüm
      Scenario: Handling devices with unreadable version info
        When the system scans for version information
        But cannot read the version registry from "Kiosk-Old"
        Then it should display "Unknown" in the version column
        And flag the device for manual inspection
        
      # İstisna Akış 3a: Sürüm Çakışması/Tutarsızlık
      Scenario: Detecting version inconsistency
        When the system detects multiple conflicting version reports from the same agent
        Then it should log a "Version Conflict Warning"
        And display the most recently received valid version
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-SC6.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_sc6 @testcase
Scenario: UC-SC6 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Software Version Tracking (UC-SC6)
      As a System Administrator
      I want to view software versions across the fleet
      So that I can identify outdated or non-compliant devices
      
      # Basic Flow: Sürüm Listeleme
      Scenario: Displaying version inventory
        When the Admin navigates to "Version Control"
        Then the system should list all devices with their software versions:
          | Device Name | OS Version | App Version | Status     |
          | Kiosk-01    | Win10      | v2.1.0      | Up-to-date |
          | Kiosk-02    | Win10      | v2.0.9      | Outdated   |
          
      # İstisna Akış 2a: Bilinmeyen Sürüm
      Scenario: Handling devices with unreadable version info
        When the system scans for version information
        But cannot read the version registry from "Kiosk-Old"
        Then it should display "Unknown" in the version column
        And flag the device for manual inspection
        
      # İstisna Akış 3a: Sürüm Çakışması/Tutarsızlık
      Scenario: Detecting version inconsistency
        When the system detects multiple conflicting version reports from the same agent
        Then it should log a "Version Conflict Warning"
        And display the most recently received valid version
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-SC6.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_sc6 @uml
Scenario: UC-SC6 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Software Version Tracking (UC-SC6)
      As a System Administrator
      I want to view software versions across the fleet
      So that I can identify outdated or non-compliant devices
      
      # Basic Flow: Sürüm Listeleme
      Scenario: Displaying version inventory
        When the Admin navigates to "Version Control"
        Then the system should list all devices with their software versions:
          | Device Name | OS Version | App Version | Status     |
          | Kiosk-01    | Win10      | v2.1.0      | Up-to-date |
          | Kiosk-02    | Win10      | v2.0.9      | Outdated   |
          
      # İstisna Akış 2a: Bilinmeyen Sürüm
      Scenario: Handling devices with unreadable version info
        When the system scans for version information
        But cannot read the version registry from "Kiosk-Old"
        Then it should display "Unknown" in the version column
        And flag the device for manual inspection
        
      # İstisna Akış 3a: Sürüm Çakışması/Tutarsızlık
      Scenario: Detecting version inconsistency
        When the system detects multiple conflicting version reports from the same agent
        Then it should log a "Version Conflict Warning"
        And display the most recently received valid version
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-SC6_Sequence.txt"
  And The file should contain valid PlantUML code
