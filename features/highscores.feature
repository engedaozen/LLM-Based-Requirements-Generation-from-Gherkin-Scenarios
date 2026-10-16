@highscores
Feature: Highscore Module Full AI Analysis (UC-H1 → UC-H6)

################################################################################
# UC-H1 – Highscore Display Viewing
################################################################################

@uc_h1 @requirement
Scenario: UC-H1 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Highscore Display Viewing (UC-H1)
      As the Highscore Display System
      I want to fetch and display scores based on configuration (Global/City/Zone)
      So that players can see the rankings clearly on large screens
      
      Background:
        Given the Highscore Display is powered on
        And connected to the network
        
      # Basic Flow: Başarılı Veri Gösterimi
      Scenario Outline: Display scores for defined scope
        Given the configuration scope is set to "<scope>"
        When the system requests the score list from the Backend Score Service
        Then the Backend should return the sorted list containing:
          | Player Name | Score | Date |
        And the system should display the scores optimized for large screens
        And auto-refresh the view every "30 seconds"
        
        Examples:
          | scope  |
          | Global |
          | City   |
          | Zone   |
          
      # Alternatif Akış A1: Backend Erişilemez (Offline)
      Scenario: Display cached data when backend is down
        When the system attempts to fetch scores
        But the Backend Score Service is unreachable
        Then the system should retrieve the last valid data from "Local Cache"
        And display an "Offline" indicator on the screen
        
      # Alternatif Akış A2: Veri Yok
      Scenario: No scores available for the scope
        When the Backend returns an empty list for the selected scope
        Then the system should display a "No scores yet" placeholder message
        And continue checking for updates periodically
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-H1.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_h1 @testcase
Scenario: UC-H1 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Highscore Display Viewing (UC-H1)
      As the Highscore Display System
      I want to fetch and display scores based on configuration (Global/City/Zone)
      So that players can see the rankings clearly on large screens
      
      Background:
        Given the Highscore Display is powered on
        And connected to the network
        
      # Basic Flow: Başarılı Veri Gösterimi
      Scenario Outline: Display scores for defined scope
        Given the configuration scope is set to "<scope>"
        When the system requests the score list from the Backend Score Service
        Then the Backend should return the sorted list containing:
          | Player Name | Score | Date |
        And the system should display the scores optimized for large screens
        And auto-refresh the view every "30 seconds"
        
        Examples:
          | scope  |
          | Global |
          | City   |
          | Zone   |
          
      # Alternatif Akış A1: Backend Erişilemez (Offline)
      Scenario: Display cached data when backend is down
        When the system attempts to fetch scores
        But the Backend Score Service is unreachable
        Then the system should retrieve the last valid data from "Local Cache"
        And display an "Offline" indicator on the screen
        
      # Alternatif Akış A2: Veri Yok
      Scenario: No scores available for the scope
        When the Backend returns an empty list for the selected scope
        Then the system should display a "No scores yet" placeholder message
        And continue checking for updates periodically
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-H1.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_h1 @uml
Scenario: UC-H1 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Highscore Display Viewing (UC-H1)
      As the Highscore Display System
      I want to fetch and display scores based on configuration (Global/City/Zone)
      So that players can see the rankings clearly on large screens
      
      Background:
        Given the Highscore Display is powered on
        And connected to the network
        
      # Basic Flow: Başarılı Veri Gösterimi
      Scenario Outline: Display scores for defined scope
        Given the configuration scope is set to "<scope>"
        When the system requests the score list from the Backend Score Service
        Then the Backend should return the sorted list containing:
          | Player Name | Score | Date |
        And the system should display the scores optimized for large screens
        And auto-refresh the view every "30 seconds"
        
        Examples:
          | scope  |
          | Global |
          | City   |
          | Zone   |
          
      # Alternatif Akış A1: Backend Erişilemez (Offline)
      Scenario: Display cached data when backend is down
        When the system attempts to fetch scores
        But the Backend Score Service is unreachable
        Then the system should retrieve the last valid data from "Local Cache"
        And display an "Offline" indicator on the screen
        
      # Alternatif Akış A2: Veri Yok
      Scenario: No scores available for the scope
        When the Backend returns an empty list for the selected scope
        Then the system should display a "No scores yet" placeholder message
        And continue checking for updates periodically
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-H1_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-H2 – Display Loop Mechanism
################################################################################

@uc_h2 @requirement
Scenario: UC-H2 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Display Loop Mechanism (UC-H2)
      As the Highscore Display System
      I want to cycle through different scopes (Global -> City -> Zone)
      So that all ranking categories get visibility without manual intervention
      
      Background:
        Given the "Loop Mode" is active in configuration
        
      # Basic Flow: Otomatik Döngü
      Scenario: Cycling through score categories
        When the display timer for "Global" scope expires
        Then the system should switch the view to "City" scope
        And fetch fresh data for "City" from the Backend
        And apply the transition seamlessly without a full page reload
        
      # Alternatif Akış A1: Döngüyü Durdurma
      Scenario: Manually stopping the loop
        Given the loop is currently running
        When the Admin sends a "Stop Loop" command
        Then the system should pause the cycle
        And remain fixed on the current scope view
        
      # İstisna Akış I1: Geçiş Sırasında Hata
      Scenario: Handling backend failure during transition
        When the system attempts to switch to "Zone" scope
        But the Backend fails to return data for "Zone"
        Then the system should display the "Last Known" data for "Zone" from cache
        And continue the loop timer for the next transition
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-H2.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_h2 @testcase
Scenario: UC-H2 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Display Loop Mechanism (UC-H2)
      As the Highscore Display System
      I want to cycle through different scopes (Global -> City -> Zone)
      So that all ranking categories get visibility without manual intervention
      
      Background:
        Given the "Loop Mode" is active in configuration
        
      # Basic Flow: Otomatik Döngü
      Scenario: Cycling through score categories
        When the display timer for "Global" scope expires
        Then the system should switch the view to "City" scope
        And fetch fresh data for "City" from the Backend
        And apply the transition seamlessly without a full page reload
        
      # Alternatif Akış A1: Döngüyü Durdurma
      Scenario: Manually stopping the loop
        Given the loop is currently running
        When the Admin sends a "Stop Loop" command
        Then the system should pause the cycle
        And remain fixed on the current scope view
        
      # İstisna Akış I1: Geçiş Sırasında Hata
      Scenario: Handling backend failure during transition
        When the system attempts to switch to "Zone" scope
        But the Backend fails to return data for "Zone"
        Then the system should display the "Last Known" data for "Zone" from cache
        And continue the loop timer for the next transition
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-H2.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_h2 @uml
Scenario: UC-H2 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Display Loop Mechanism (UC-H2)
      As the Highscore Display System
      I want to cycle through different scopes (Global -> City -> Zone)
      So that all ranking categories get visibility without manual intervention
      
      Background:
        Given the "Loop Mode" is active in configuration
        
      # Basic Flow: Otomatik Döngü
      Scenario: Cycling through score categories
        When the display timer for "Global" scope expires
        Then the system should switch the view to "City" scope
        And fetch fresh data for "City" from the Backend
        And apply the transition seamlessly without a full page reload
        
      # Alternatif Akış A1: Döngüyü Durdurma
      Scenario: Manually stopping the loop
        Given the loop is currently running
        When the Admin sends a "Stop Loop" command
        Then the system should pause the cycle
        And remain fixed on the current scope view
        
      # İstisna Akış I1: Geçiş Sırasında Hata
      Scenario: Handling backend failure during transition
        When the system attempts to switch to "Zone" scope
        But the Backend fails to return data for "Zone"
        Then the system should display the "Last Known" data for "Zone" from cache
        And continue the loop timer for the next transition
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-H2_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-H3 – Periodic Score Update
################################################################################

@uc_h3 @requirement
Scenario: UC-H3 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Periodic Score Update (UC-H3)
      As the Highscore Display System
      I want to update the data periodically
      So that the displayed information remains current

      # Basic Flow: Sessiz Güncelleme (Silent Update)
      Scenario: Updating scores without visual disruption
        Given The update timer (e.g., 30s) has triggered
        When The system fetches new data from the Backend
        Then The system should update the DOM/UI elements with new values
        And The update should happen "silently" (no page reload or blink)

      # Alternatif Akış A1: Güncelleme Başarısız
      Scenario: Handling update failure gracefully
        When The system attempts a periodic update
        But The network request fails
        Then The system should keep displaying the existing data
        And Show a "Data stale / Update failed" warning icon
        And Retry at the next scheduled interval
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-H3.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_h3 @testcase
Scenario: UC-H3 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Periodic Score Update (UC-H3)
      As the Highscore Display System
      I want to update the data periodically
      So that the displayed information remains current

      # Basic Flow: Sessiz Güncelleme (Silent Update)
      Scenario: Updating scores without visual disruption
        Given The update timer (e.g., 30s) has triggered
        When The system fetches new data from the Backend
        Then The system should update the DOM/UI elements with new values
        And The update should happen "silently" (no page reload or blink)

      # Alternatif Akış A1: Güncelleme Başarısız
      Scenario: Handling update failure gracefully
        When The system attempts a periodic update
        But The network request fails
        Then The system should keep displaying the existing data
        And Show a "Data stale / Update failed" warning icon
        And Retry at the next scheduled interval
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-H3.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_h3 @uml
Scenario: UC-H3 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Periodic Score Update (UC-H3)
      As the Highscore Display System
      I want to update the data periodically
      So that the displayed information remains current

      # Basic Flow: Sessiz Güncelleme (Silent Update)
      Scenario: Updating scores without visual disruption
        Given The update timer (e.g., 30s) has triggered
        When The system fetches new data from the Backend
        Then The system should update the DOM/UI elements with new values
        And The update should happen "silently" (no page reload or blink)

      # Alternatif Akış A1: Güncelleme Başarısız
      Scenario: Handling update failure gracefully
        When The system attempts a periodic update
        But The network request fails
        Then The system should keep displaying the existing data
        And Show a "Data stale / Update failed" warning icon
        And Retry at the next scheduled interval
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-H3_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-H4 – Score Validation and Anomaly Filtering
################################################################################

@uc_h4 @requirement
Scenario: UC-H4 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Score Validation and Anomaly Filtering (UC-H4)
      As the System
      I want to filter out invalid or anomalous scores
      So that the leaderboard remains fair and trustworthy
      
      # Basic Flow: Geçerli Skorları Gösterme
      Scenario: Displaying only validated scores
        When the system receives a raw list of scores from the Backend
        And applies validation rules (Max Score Limit, Digital Signature)
        Then it should filter out any score marked as "Suspicious" or "Invalid"
        And display only the clean list of scores
        
      # Alternatif Akış A1: Doğrulama Servisi Hatası
      Scenario: Fallback when validation service is down
        When the validation service is unreachable
        Then the system should revert to the "Last Successfully Validated" list from cache
        And display a warning "Verification service unavailable"
        
      # Alternatif Akış A2: Tüm Skorlar Geçersiz
      Scenario: All scores rejected by validation
        When the validation process rejects all incoming scores
        Then the system should display a "No validated scores available" message
        And should NOT display raw/unverified data
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-H4.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_h4 @testcase
Scenario: UC-H4 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Score Validation and Anomaly Filtering (UC-H4)
      As the System
      I want to filter out invalid or anomalous scores
      So that the leaderboard remains fair and trustworthy
      
      # Basic Flow: Geçerli Skorları Gösterme
      Scenario: Displaying only validated scores
        When the system receives a raw list of scores from the Backend
        And applies validation rules (Max Score Limit, Digital Signature)
        Then it should filter out any score marked as "Suspicious" or "Invalid"
        And display only the clean list of scores
        
      # Alternatif Akış A1: Doğrulama Servisi Hatası
      Scenario: Fallback when validation service is down
        When the validation service is unreachable
        Then the system should revert to the "Last Successfully Validated" list from cache
        And display a warning "Verification service unavailable"
        
      # Alternatif Akış A2: Tüm Skorlar Geçersiz
      Scenario: All scores rejected by validation
        When the validation process rejects all incoming scores
        Then the system should display a "No validated scores available" message
        And should NOT display raw/unverified data
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-H4.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_h4 @uml
Scenario: UC-H4 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Score Validation and Anomaly Filtering (UC-H4)
      As the System
      I want to filter out invalid or anomalous scores
      So that the leaderboard remains fair and trustworthy
      
      # Basic Flow: Geçerli Skorları Gösterme
      Scenario: Displaying only validated scores
        When the system receives a raw list of scores from the Backend
        And applies validation rules (Max Score Limit, Digital Signature)
        Then it should filter out any score marked as "Suspicious" or "Invalid"
        And display only the clean list of scores
        
      # Alternatif Akış A1: Doğrulama Servisi Hatası
      Scenario: Fallback when validation service is down
        When the validation service is unreachable
        Then the system should revert to the "Last Successfully Validated" list from cache
        And display a warning "Verification service unavailable"
        
      # Alternatif Akış A2: Tüm Skorlar Geçersiz
      Scenario: All scores rejected by validation
        When the validation process rejects all incoming scores
        Then the system should display a "No validated scores available" message
        And should NOT display raw/unverified data
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-H4_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-H5 – Offline Cache Display
################################################################################

@uc_h5 @requirement
Scenario: UC-H5 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Cache Display (UC-H5)
      As the Highscore Display System
      I want to show cached content during network outages
      So that the screen never goes black or shows an error page
      
      Background:
        Given the system has previously fetched and cached data
        
      # Basic Flow: Offline Gösterim
      Scenario: Serving content from local cache
        Given the network connection is lost
        When the system needs to refresh the display
        Then it should load the data from "Local Storage"
        And render the score table
        And display a "Offline Mode" badge
        
      # Basic Flow: Yeniden Bağlanma (Reconnection)
      Scenario: Auto-recovery when network returns
        Given the system is in "Offline Mode"
        When the network connection is restored
        Then the system should automatically fetch fresh data
        And update the screen
        And remove the "Offline Mode" badge
        
      # Alternatif Akış A1: Cache Boş
      Scenario: No cache available during outage
        Given the local cache is empty
        And the network is down
        When the system tries to display scores
        Then it should show a generic "Service Unavailable" screen
        And retry connection in background
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-H5.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_h5 @testcase
Scenario: UC-H5 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Cache Display (UC-H5)
      As the Highscore Display System
      I want to show cached content during network outages
      So that the screen never goes black or shows an error page
      
      Background:
        Given the system has previously fetched and cached data
        
      # Basic Flow: Offline Gösterim
      Scenario: Serving content from local cache
        Given the network connection is lost
        When the system needs to refresh the display
        Then it should load the data from "Local Storage"
        And render the score table
        And display a "Offline Mode" badge
        
      # Basic Flow: Yeniden Bağlanma (Reconnection)
      Scenario: Auto-recovery when network returns
        Given the system is in "Offline Mode"
        When the network connection is restored
        Then the system should automatically fetch fresh data
        And update the screen
        And remove the "Offline Mode" badge
        
      # Alternatif Akış A1: Cache Boş
      Scenario: No cache available during outage
        Given the local cache is empty
        And the network is down
        When the system tries to display scores
        Then it should show a generic "Service Unavailable" screen
        And retry connection in background
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-H5.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_h5 @uml
Scenario: UC-H5 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Offline Cache Display (UC-H5)
      As the Highscore Display System
      I want to show cached content during network outages
      So that the screen never goes black or shows an error page
      
      Background:
        Given the system has previously fetched and cached data
        
      # Basic Flow: Offline Gösterim
      Scenario: Serving content from local cache
        Given the network connection is lost
        When the system needs to refresh the display
        Then it should load the data from "Local Storage"
        And render the score table
        And display a "Offline Mode" badge
        
      # Basic Flow: Yeniden Bağlanma (Reconnection)
      Scenario: Auto-recovery when network returns
        Given the system is in "Offline Mode"
        When the network connection is restored
        Then the system should automatically fetch fresh data
        And update the screen
        And remove the "Offline Mode" badge
        
      # Alternatif Akış A1: Cache Boş
      Scenario: No cache available during outage
        Given the local cache is empty
        And the network is down
        When the system tries to display scores
        Then it should show a generic "Service Unavailable" screen
        And retry connection in background
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-H5_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-H6 – Screen Layout and Theme Management
################################################################################

@uc_h6 @requirement
Scenario: UC-H6 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Screen Layout and Theme Management (UC-H6)
      As an Admin
      I want to change the visual theme and layout of the display
      So that it matches the venue's branding or specific events
      
      Background:
        Given the Highscore Display is running
        
      # Basic Flow: Tema Değişikliği
      Scenario Outline: Applying new visual settings
        Given the Admin is on the "Display Settings" panel
        When the Admin updates "<setting>" to "<value>"
        And clicks "Save"
        Then the Backend should push the new configuration to the Display Client
        And the Display Client should apply the changes immediately without restart
        
        Examples:
          | setting     | value     |
          | Theme Color | Dark Blue |
          | Font Size   | Large     |
          | Layout      | 2-Columns |
          
      # Alternatif Akış A1: Uygulama Hatası
      Scenario: Display client fails to apply settings
        When the Admin sends a new configuration
        But the Display Client cannot parse the settings
        Then the system should report "Configuration Failed" to the Admin
        And the Display Client should revert to the previous working theme
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-H6.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_h6 @testcase
Scenario: UC-H6 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Screen Layout and Theme Management (UC-H6)
      As an Admin
      I want to change the visual theme and layout of the display
      So that it matches the venue's branding or specific events
      
      Background:
        Given the Highscore Display is running
        
      # Basic Flow: Tema Değişikliği
      Scenario Outline: Applying new visual settings
        Given the Admin is on the "Display Settings" panel
        When the Admin updates "<setting>" to "<value>"
        And clicks "Save"
        Then the Backend should push the new configuration to the Display Client
        And the Display Client should apply the changes immediately without restart
        
        Examples:
          | setting     | value     |
          | Theme Color | Dark Blue |
          | Font Size   | Large     |
          | Layout      | 2-Columns |
          
      # Alternatif Akış A1: Uygulama Hatası
      Scenario: Display client fails to apply settings
        When the Admin sends a new configuration
        But the Display Client cannot parse the settings
        Then the system should report "Configuration Failed" to the Admin
        And the Display Client should revert to the previous working theme
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-H6.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_h6 @uml
Scenario: UC-H6 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Screen Layout and Theme Management (UC-H6)
      As an Admin
      I want to change the visual theme and layout of the display
      So that it matches the venue's branding or specific events
      
      Background:
        Given the Highscore Display is running
        
      # Basic Flow: Tema Değişikliği
      Scenario Outline: Applying new visual settings
        Given the Admin is on the "Display Settings" panel
        When the Admin updates "<setting>" to "<value>"
        And clicks "Save"
        Then the Backend should push the new configuration to the Display Client
        And the Display Client should apply the changes immediately without restart
        
        Examples:
          | setting     | value     |
          | Theme Color | Dark Blue |
          | Font Size   | Large     |
          | Layout      | 2-Columns |
          
      # Alternatif Akış A1: Uygulama Hatası
      Scenario: Display client fails to apply settings
        When the Admin sends a new configuration
        But the Display Client cannot parse the settings
        Then the system should report "Configuration Failed" to the Admin
        And the Display Client should revert to the previous working theme
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-H6_Sequence.txt"
  And The file should contain valid PlantUML code
