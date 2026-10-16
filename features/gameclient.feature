@gameclient
Feature: GameClient Module Full AI Analysis (UC-G1 → UC-G6)

################################################################################
# UC-G1 – Game Session Initiation
################################################################################

@uc_g1 @requirement
Scenario: UC-G1 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Game Session Initiation (UC-G1)
      As the GameClient Software
      I want to initialize a new game session upon request
      So that the player can start the game with correct parameter
      
      Background:
        Given the GameClient is in "Idle" state
        And the Kiosk has triggered a "Start Session" command
        
        # Basic Flow: Başarılı Başlatma
        Scenario: Successfully start game engine with backend parameters
          When the GameClient receives the start command
          And requests game parameters from the Backend Session Service
          Then the Backend should return valid parameters (difficulty, duration)
          And the GameClient should generate a unique Session ID
          And the Game Engine should initialize and start the gameplay
          
        # İstisna Akış I1: Backend Yoksa Cache Kullan
        Scenario: Start game using cached parameters when backend is down
          When the GameClient requests game parameters
          But the Backend Session Service is unreachable
          Then the GameClient should load the "Default" or "Last Known" parameters from local cache
          And the Game Engine should start in "Offline Mode"
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-G1.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_g1 @testcase
Scenario: UC-G1 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Game Session Initiation (UC-G1)
      As the GameClient Software
      I want to initialize a new game session upon request
      So that the player can start the game with correct parameter
      
      Background:
        Given the GameClient is in "Idle" state
        And the Kiosk has triggered a "Start Session" command
        
        # Basic Flow: Başarılı Başlatma
        Scenario: Successfully start game engine with backend parameters
          When the GameClient receives the start command
          And requests game parameters from the Backend Session Service
          Then the Backend should return valid parameters (difficulty, duration)
          And the GameClient should generate a unique Session ID
          And the Game Engine should initialize and start the gameplay
          
        # İstisna Akış I1: Backend Yoksa Cache Kullan
        Scenario: Start game using cached parameters when backend is down
          When the GameClient requests game parameters
          But the Backend Session Service is unreachable
          Then the GameClient should load the "Default" or "Last Known" parameters from local cache
          And the Game Engine should start in "Offline Mode"
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-G1.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_g1 @uml
Scenario: UC-G1 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Game Session Initiation (UC-G1)
      As the GameClient Software
      I want to initialize a new game session upon request
      So that the player can start the game with correct parameter
      
      Background:
        Given the GameClient is in "Idle" state
        And the Kiosk has triggered a "Start Session" command
        
        # Basic Flow: Başarılı Başlatma
        Scenario: Successfully start game engine with backend parameters
          When the GameClient receives the start command
          And requests game parameters from the Backend Session Service
          Then the Backend should return valid parameters (difficulty, duration)
          And the GameClient should generate a unique Session ID
          And the Game Engine should initialize and start the gameplay
          
        # İstisna Akış I1: Backend Yoksa Cache Kullan
        Scenario: Start game using cached parameters when backend is down
          When the GameClient requests game parameters
          But the Backend Session Service is unreachable
          Then the GameClient should load the "Default" or "Last Known" parameters from local cache
          And the Game Engine should start in "Offline Mode"
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-G1_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-G2 – Real-time Telemetry Transmission
################################################################################

@uc_g2 @requirement
Scenario: UC-G2 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Telemetry Transmission (UC-G2)
      As the Backend System
      I want to receive periodic telemetry from the GameClient
      So that I can monitor the game health and player activity
      
      Background:
        Given the game session is currently active
        
        # Basic Flow: Periyodik Gönderim
        Scenario: Periodic telemetry sending and acknowledgement
          When the GameClient generates telemetry data (FPS, player position, health)
          And sends the data packet to the Backend Telemetry Service
          Then the Backend should return an "Acknowledgement" (ACK) signal
          And the GameClient should clear the sent data from memory
          
        # İstisna Akış I1: Bağlantı Hatası ve Kuyruklama
        Scenario: Queue telemetry when connection is lost
          When the GameClient attempts to send telemetry data
          But the network connection is lost
          Then the GameClient should add the data to a "Local Telemetry Queue"
          And should retry sending when the connection is restored
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-G2.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_g2 @testcase
Scenario: UC-G2 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Telemetry Transmission (UC-G2)
      As the Backend System
      I want to receive periodic telemetry from the GameClient
      So that I can monitor the game health and player activity
      
      Background:
        Given the game session is currently active
        
        # Basic Flow: Periyodik Gönderim
        Scenario: Periodic telemetry sending and acknowledgement
          When the GameClient generates telemetry data (FPS, player position, health)
          And sends the data packet to the Backend Telemetry Service
          Then the Backend should return an "Acknowledgement" (ACK) signal
          And the GameClient should clear the sent data from memory
          
        # İstisna Akış I1: Bağlantı Hatası ve Kuyruklama
        Scenario: Queue telemetry when connection is lost
          When the GameClient attempts to send telemetry data
          But the network connection is lost
          Then the GameClient should add the data to a "Local Telemetry Queue"
          And should retry sending when the connection is restored
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-G2.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_g2 @uml
Scenario: UC-G2 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Real-time Telemetry Transmission (UC-G2)
      As the Backend System
      I want to receive periodic telemetry from the GameClient
      So that I can monitor the game health and player activity
      
      Background:
        Given the game session is currently active
        
        # Basic Flow: Periyodik Gönderim
        Scenario: Periodic telemetry sending and acknowledgement
          When the GameClient generates telemetry data (FPS, player position, health)
          And sends the data packet to the Backend Telemetry Service
          Then the Backend should return an "Acknowledgement" (ACK) signal
          And the GameClient should clear the sent data from memory
          
        # İstisna Akış I1: Bağlantı Hatası ve Kuyruklama
        Scenario: Queue telemetry when connection is lost
          When the GameClient attempts to send telemetry data
          But the network connection is lost
          Then the GameClient should add the data to a "Local Telemetry Queue"
          And should retry sending when the connection is restored
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-G2_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-G3 – Game End and Score Submission
################################################################################

@uc_g3 @requirement
Scenario: UC-G3 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Game End and Score Submission (UC-G3)
      As the GameClient
      I want to finalize the session and submit the score
      So that the player's performance is recorded
      
      Background:
        Given the game objective has been completed or time has expired
        
        # Basic Flow: Başarılı Skor Gönderimi
        Scenario: Calculate and submit score
          When the GameClient calculates the final score
          And sends the score payload to the Backend Score Service
          Then the Backend should validate and accept the score
          And the GameClient should close the session
          And return to "Idle" state
          
        # İstisna Akış I1: Backend Doğrulama Hatası
        Scenario: Handle score verification failure
          When the GameClient submits the score
          But the Backend responds with a "Verification Error"
          Then the GameClient should mark the score as "Pending Review" locally
          And should not discard the session data immediately
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-G3.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_g3 @testcase
Scenario: UC-G3 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Game End and Score Submission (UC-G3)
      As the GameClient
      I want to finalize the session and submit the score
      So that the player's performance is recorded
      
      Background:
        Given the game objective has been completed or time has expired
        
        # Basic Flow: Başarılı Skor Gönderimi
        Scenario: Calculate and submit score
          When the GameClient calculates the final score
          And sends the score payload to the Backend Score Service
          Then the Backend should validate and accept the score
          And the GameClient should close the session
          And return to "Idle" state
          
        # İstisna Akış I1: Backend Doğrulama Hatası
        Scenario: Handle score verification failure
          When the GameClient submits the score
          But the Backend responds with a "Verification Error"
          Then the GameClient should mark the score as "Pending Review" locally
          And should not discard the session data immediately
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-G3.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_g3 @uml
Scenario: UC-G3 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Game End and Score Submission (UC-G3)
      As the GameClient
      I want to finalize the session and submit the score
      So that the player's performance is recorded
      
      Background:
        Given the game objective has been completed or time has expired
        
        # Basic Flow: Başarılı Skor Gönderimi
        Scenario: Calculate and submit score
          When the GameClient calculates the final score
          And sends the score payload to the Backend Score Service
          Then the Backend should validate and accept the score
          And the GameClient should close the session
          And return to "Idle" state
          
        # İstisna Akış I1: Backend Doğrulama Hatası
        Scenario: Handle score verification failure
          When the GameClient submits the score
          But the Backend responds with a "Verification Error"
          Then the GameClient should mark the score as "Pending Review" locally
          And should not discard the session data immediately
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-G3_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-G4 – Auto-Reconnect Mechanism
################################################################################

@uc_g4 @requirement
Scenario: UC-G4 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Auto-Reconnect Mechanism (UC-G4)
      As the GameClient
      I want to automatically reconnect after a network drop
      So that the game data is not lost
      
      Background:
        Given the game is running
        And the network connection has been lost
        
        # Basic Flow: Otomatik Yeniden Bağlanma
        Scenario: Detect loss and successfully reconnect
          When the GameClient detects a disconnection
          Then it should attempt to reconnect every 5 seconds
          When the connection is re-established
          Then the GameClient should flush the "Local Telemetry Queue" to the server
          And continue normal operation
          
        # İstisna Akış I1: Bağlantı Hiç Gelmezse
        Scenario: Permanent connection loss (Offline Mode)
          When the GameClient attempts to reconnect multiple times without success
          Then the game should continue until the end
          And the final score should be saved in "Local Storage"
          And marked for "Sync on Next Boot"
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-G4.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_g4 @testcase
Scenario: UC-G4 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Auto-Reconnect Mechanism (UC-G4)
      As the GameClient
      I want to automatically reconnect after a network drop
      So that the game data is not lost
      
      Background:
        Given the game is running
        And the network connection has been lost
        
        # Basic Flow: Otomatik Yeniden Bağlanma
        Scenario: Detect loss and successfully reconnect
          When the GameClient detects a disconnection
          Then it should attempt to reconnect every 5 seconds
          When the connection is re-established
          Then the GameClient should flush the "Local Telemetry Queue" to the server
          And continue normal operation
          
        # İstisna Akış I1: Bağlantı Hiç Gelmezse
        Scenario: Permanent connection loss (Offline Mode)
          When the GameClient attempts to reconnect multiple times without success
          Then the game should continue until the end
          And the final score should be saved in "Local Storage"
          And marked for "Sync on Next Boot"
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-G4.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_g4 @uml
Scenario: UC-G4 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Auto-Reconnect Mechanism (UC-G4)
      As the GameClient
      I want to automatically reconnect after a network drop
      So that the game data is not lost
      
      Background:
        Given the game is running
        And the network connection has been lost
        
        # Basic Flow: Otomatik Yeniden Bağlanma
        Scenario: Detect loss and successfully reconnect
          When the GameClient detects a disconnection
          Then it should attempt to reconnect every 5 seconds
          When the connection is re-established
          Then the GameClient should flush the "Local Telemetry Queue" to the server
          And continue normal operation
          
        # İstisna Akış I1: Bağlantı Hiç Gelmezse
        Scenario: Permanent connection loss (Offline Mode)
          When the GameClient attempts to reconnect multiple times without success
          Then the game should continue until the end
          And the final score should be saved in "Local Storage"
          And marked for "Sync on Next Boot"
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-G4_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-G5 – Remote Management
################################################################################

@uc_g5 @requirement
Scenario: UC-G5 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Remote Management (UC-G5)
      As a System Admin
      I want to send remote commands to the GameClient
      So that I can manage the device without physical access
      
      Background:
        Given the GameClient is online and listening for commands
        
        # Basic Flow: Uzaktan Komut İşleme
        Scenario Outline: Execute remote commands successfully
          When the Backend sends a "<command>" signal
          Then the GameClient should validate the command signature
          And execute the "<action>" process
          And report the result back to the Backend
          
          Examples:
            | command | action               |
            | STOP    | End current session  |
            | RESTART | Reboot application   |
            | UPDATE  | Download patch files |
            
        # İstisna Akış I1: Restart Başarısız (Watchdog)
        Scenario: Watchdog activation on freeze
          When the GameClient attempts to restart but freezes
          Then the Hardware Watchdog should detect the inactivity
          And force a hard reset of the system
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-G5.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_g5 @testcase
Scenario: UC-G5 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Remote Management (UC-G5)
      As a System Admin
      I want to send remote commands to the GameClient
      So that I can manage the device without physical access
      
      Background:
        Given the GameClient is online and listening for commands
        
        # Basic Flow: Uzaktan Komut İşleme
        Scenario Outline: Execute remote commands successfully
          When the Backend sends a "<command>" signal
          Then the GameClient should validate the command signature
          And execute the "<action>" process
          And report the result back to the Backend
          
          Examples:
            | command | action               |
            | STOP    | End current session  |
            | RESTART | Reboot application   |
            | UPDATE  | Download patch files |
            
        # İstisna Akış I1: Restart Başarısız (Watchdog)
        Scenario: Watchdog activation on freeze
          When the GameClient attempts to restart but freezes
          Then the Hardware Watchdog should detect the inactivity
          And force a hard reset of the system
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-G5.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_g5 @uml
Scenario: UC-G5 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Remote Management (UC-G5)
      As a System Admin
      I want to send remote commands to the GameClient
      So that I can manage the device without physical access
      
      Background:
        Given the GameClient is online and listening for commands
        
        # Basic Flow: Uzaktan Komut İşleme
        Scenario Outline: Execute remote commands successfully
          When the Backend sends a "<command>" signal
          Then the GameClient should validate the command signature
          And execute the "<action>" process
          And report the result back to the Backend
          
          Examples:
            | command | action               |
            | STOP    | End current session  |
            | RESTART | Reboot application   |
            | UPDATE  | Download patch files |
            
        # İstisna Akış I1: Restart Başarısız (Watchdog)
        Scenario: Watchdog activation on freeze
          When the GameClient attempts to restart but freezes
          Then the Hardware Watchdog should detect the inactivity
          And force a hard reset of the system
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-G5_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-G6 – In-Game Settings Persistence
################################################################################

@uc_g6 @requirement
Scenario: UC-G6 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: In-Game Settings Persistence (UC-G6)
      As a Player
      I want my game customization settings to be saved
      So that I don't have to re-adjust them every time
      
      Background:
        Given the game session is active
        
        # Basic Flow: Ayarları Kaydetme
        Scenario Outline: User changes settings
          When the user changes the "<setting_type>" to "<value>"
          Then the GameClient should apply the setting immediately
          And send the new configuration to the Backend Settings Service
          And the Backend should confirm storage
          
          Examples:
            | setting_type | value |
            | Volume       | 80%   |
            | Difficulty   | Hard  |
            | Language     | TR    |
            
        # İstisna Akış I1: Backend Yoksa Lokal Kayıt
        Scenario: Sync settings later if backend is down
          When the user updates a setting
          But the Backend is unreachable
          Then the GameClient should save the setting to a local configuration file
          And sync with the Backend automatically when online
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-G6.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_g6 @testcase
Scenario: UC-G6 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: In-Game Settings Persistence (UC-G6)
      As a Player
      I want my game customization settings to be saved
      So that I don't have to re-adjust them every time
      
      Background:
        Given the game session is active
        
        # Basic Flow: Ayarları Kaydetme
        Scenario Outline: User changes settings
          When the user changes the "<setting_type>" to "<value>"
          Then the GameClient should apply the setting immediately
          And send the new configuration to the Backend Settings Service
          And the Backend should confirm storage
          
          Examples:
            | setting_type | value |
            | Volume       | 80%   |
            | Difficulty   | Hard  |
            | Language     | TR    |
            
        # İstisna Akış I1: Backend Yoksa Lokal Kayıt
        Scenario: Sync settings later if backend is down
          When the user updates a setting
          But the Backend is unreachable
          Then the GameClient should save the setting to a local configuration file
          And sync with the Backend automatically when online
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-G6.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_g6 @uml
Scenario: UC-G6 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: In-Game Settings Persistence (UC-G6)
      As a Player
      I want my game customization settings to be saved
      So that I don't have to re-adjust them every time
      
      Background:
        Given the game session is active
        
        # Basic Flow: Ayarları Kaydetme
        Scenario Outline: User changes settings
          When the user changes the "<setting_type>" to "<value>"
          Then the GameClient should apply the setting immediately
          And send the new configuration to the Backend Settings Service
          And the Backend should confirm storage
          
          Examples:
            | setting_type | value |
            | Volume       | 80%   |
            | Difficulty   | Hard  |
            | Language     | TR    |
            
        # İstisna Akış I1: Backend Yoksa Lokal Kayıt
        Scenario: Sync settings later if backend is down
          When the user updates a setting
          But the Backend is unreachable
          Then the GameClient should save the setting to a local configuration file
          And sync with the Backend automatically when online
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-G6_Sequence.txt"
  And The file should contain valid PlantUML code
