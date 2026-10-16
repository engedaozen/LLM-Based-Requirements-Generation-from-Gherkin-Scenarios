@dashboard
Feature: Dashboard Module Full AI Analysis (UC-D1 → UC-D6)

################################################################################
# UC-D1 – Secure Login and Session Management
################################################################################

@uc_d1 @requirement
Scenario: UC-D1 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Secure Login and Session Management (UC-D1)
      As a User (Cashier, Manager, Admin)
      I want to log in securely and have my session managed
      So that unauthorized access is prevented and my session remains active while I work
    
      # Basic Flow: Başarılı Giriş
      Scenario Outline: User logs in and is redirected based on role
        Given the user is on the Login Page
        When the user enters valid username "<username>" and password "<password>"
        And clicks the "Login" button
        Then the Backend Authentication Service should verify the credentials
        And the user should be redirected to the "<role_dashboard>"
    
        Examples:
          | username | password | role_dashboard    |
          | cashier1 | Pass123! | Cashier Dashboard |
          | admin1   | Secr3t!  | Admin Dashboard   |
    
      # Basic Flow & A2: Session Timeout ve Yenileme
      Scenario: Session timeout warning and renewal
        Given the user is logged in
        And the session is approaching the timeout limit (e.g., 2 minutes left)
        When the system displays the "Session ending soon" warning
        And the user clicks "Extend Session"
        Then the session timer should be reset
        And the user should remain on the current screen
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-D1.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_d1 @testcase
Scenario: UC-D1 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Secure Login and Session Management (UC-D1)
      As a User (Cashier, Manager, Admin)
      I want to log in securely and have my session managed
      So that unauthorized access is prevented and my session remains active while I work
    
      # Basic Flow: Başarılı Giriş
      Scenario Outline: User logs in and is redirected based on role
        Given the user is on the Login Page
        When the user enters valid username "<username>" and password "<password>"
        And clicks the "Login" button
        Then the Backend Authentication Service should verify the credentials
        And the user should be redirected to the "<role_dashboard>"
    
        Examples:
          | username | password | role_dashboard    |
          | cashier1 | Pass123! | Cashier Dashboard |
          | admin1   | Secr3t!  | Admin Dashboard   |
    
      # Basic Flow & A2: Session Timeout ve Yenileme
      Scenario: Session timeout warning and renewal
        Given the user is logged in
        And the session is approaching the timeout limit (e.g., 2 minutes left)
        When the system displays the "Session ending soon" warning
        And the user clicks "Extend Session"
        Then the session timer should be reset
        And the user should remain on the current screen
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-D1.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_d1 @uml
Scenario: UC-D1 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Secure Login and Session Management (UC-D1)
      As a User (Cashier, Manager, Admin)
      I want to log in securely and have my session managed
      So that unauthorized access is prevented and my session remains active while I work
    
      # Basic Flow: Başarılı Giriş
      Scenario Outline: User logs in and is redirected based on role
        Given the user is on the Login Page
        When the user enters valid username "<username>" and password "<password>"
        And clicks the "Login" button
        Then the Backend Authentication Service should verify the credentials
        And the user should be redirected to the "<role_dashboard>"
    
        Examples:
          | username | password | role_dashboard    |
          | cashier1 | Pass123! | Cashier Dashboard |
          | admin1   | Secr3t!  | Admin Dashboard   |
    
      # Basic Flow & A2: Session Timeout ve Yenileme
      Scenario: Session timeout warning and renewal
        Given the user is logged in
        And the session is approaching the timeout limit (e.g., 2 minutes left)
        When the system displays the "Session ending soon" warning
        And the user clicks "Extend Session"
        Then the session timer should be reset
        And the user should remain on the current screen
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-D1_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-D2 – Dashboard Viewing and Monitoring
################################################################################

@uc_d2 @requirement
Scenario: UC-D2 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Dashboard Viewing and Monitoring (UC-D2)
      As a Manager or Admin
      I want to view real-time operational metrics
      So that I can monitor the facility's performance
      
      Background:
        Given the user is logged in with viewing permissions
        And navigates to the Dashboard
        
      # Basic Flow: Başarılı Veri Gösterimi
      Scenario: Dashboard loads with real-time data
        When the system requests metrics from the Backend Data Service
        Then the Dashboard should display:
          | Metric Type   | Visualization |
          | Zone Occupancy| Heatmap       |
          | Daily Revenue | Line Chart    |
          | Active Alerts | List View     |
        And the data should auto-refresh every "30 seconds"
        
      # Alternatif Akış A1: Veri Alınamıyor
      Scenario: Handling backend data failure
        When the Backend Data Service fails to respond
        Then the system should display a "Data unavailable" warning
        But the Dashboard should display the "Last Known" cached values instead of a blank screen
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-D2.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_d2 @testcase
Scenario: UC-D2 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Dashboard Viewing and Monitoring (UC-D2)
      As a Manager or Admin
      I want to view real-time operational metrics
      So that I can monitor the facility's performance
      
      Background:
        Given the user is logged in with viewing permissions
        And navigates to the Dashboard
        
      # Basic Flow: Başarılı Veri Gösterimi
      Scenario: Dashboard loads with real-time data
        When the system requests metrics from the Backend Data Service
        Then the Dashboard should display:
          | Metric Type   | Visualization |
          | Zone Occupancy| Heatmap       |
          | Daily Revenue | Line Chart    |
          | Active Alerts | List View     |
        And the data should auto-refresh every "30 seconds"
        
      # Alternatif Akış A1: Veri Alınamıyor
      Scenario: Handling backend data failure
        When the Backend Data Service fails to respond
        Then the system should display a "Data unavailable" warning
        But the Dashboard should display the "Last Known" cached values instead of a blank screen
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-D2.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_d2 @uml
Scenario: UC-D2 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Dashboard Viewing and Monitoring (UC-D2)
      As a Manager or Admin
      I want to view real-time operational metrics
      So that I can monitor the facility's performance
      
      Background:
        Given the user is logged in with viewing permissions
        And navigates to the Dashboard
        
      # Basic Flow: Başarılı Veri Gösterimi
      Scenario: Dashboard loads with real-time data
        When the system requests metrics from the Backend Data Service
        Then the Dashboard should display:
          | Metric Type   | Visualization |
          | Zone Occupancy| Heatmap       |
          | Daily Revenue | Line Chart    |
          | Active Alerts | List View     |
        And the data should auto-refresh every "30 seconds"
        
      # Alternatif Akış A1: Veri Alınamıyor
      Scenario: Handling backend data failure
        When the Backend Data Service fails to respond
        Then the system should display a "Data unavailable" warning
        But the Dashboard should display the "Last Known" cached values instead of a blank screen
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-D2_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-D3 – Role and Permission Management
################################################################################

@uc_d3 @requirement
Scenario: UC-D3 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Role and Permission Management (UC-D3)
      As an Admin
      I want to manage user roles and permissions
      So that users only have access to functions relevant to their job
      
      Background:
        Given the Admin is on the "Role Management" screen
        
      # Basic Flow: Yetki Düzenleme
      Scenario: Updating permissions for a role
        When the Admin selects the role "Cashier"
        And adds the permission "View Reports"
        And clicks "Save Changes"
        Then the system should update the role definition in the Backend
        And display a "Permissions updated successfully" message
        
      # İstisna Akış I1: Geçersiz Kombinasyon
      Scenario: Preventing invalid permission combinations
        When the Admin selects a role
        And selects conflicting permissions (e.g., "View Only" AND "Edit All")
        Then the system should prevent saving
        And display an "Invalid permission combination" error
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-D3.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_d3 @testcase
Scenario: UC-D3 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Role and Permission Management (UC-D3)
      As an Admin
      I want to manage user roles and permissions
      So that users only have access to functions relevant to their job
      
      Background:
        Given the Admin is on the "Role Management" screen
        
      # Basic Flow: Yetki Düzenleme
      Scenario: Updating permissions for a role
        When the Admin selects the role "Cashier"
        And adds the permission "View Reports"
        And clicks "Save Changes"
        Then the system should update the role definition in the Backend
        And display a "Permissions updated successfully" message
        
      # İstisna Akış I1: Geçersiz Kombinasyon
      Scenario: Preventing invalid permission combinations
        When the Admin selects a role
        And selects conflicting permissions (e.g., "View Only" AND "Edit All")
        Then the system should prevent saving
        And display an "Invalid permission combination" error
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-D3.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_d3 @uml
Scenario: UC-D3 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Role and Permission Management (UC-D3)
      As an Admin
      I want to manage user roles and permissions
      So that users only have access to functions relevant to their job
      
      Background:
        Given the Admin is on the "Role Management" screen
        
      # Basic Flow: Yetki Düzenleme
      Scenario: Updating permissions for a role
        When the Admin selects the role "Cashier"
        And adds the permission "View Reports"
        And clicks "Save Changes"
        Then the system should update the role definition in the Backend
        And display a "Permissions updated successfully" message
        
      # İstisna Akış I1: Geçersiz Kombinasyon
      Scenario: Preventing invalid permission combinations
        When the Admin selects a role
        And selects conflicting permissions (e.g., "View Only" AND "Edit All")
        Then the system should prevent saving
        And display an "Invalid permission combination" error
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-D3_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-D4 – Configuration Management (Zone, Game, Pricing)
################################################################################

@uc_d4 @requirement
Scenario: UC-D4 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Management (Zone, Game, Pricing) (UC-D4)
      As a Manager or Admin
      I want to configure zones, games, and pricing
      So that I can manage the facility operations and revenue
      
      # Basic Flow: Ayar Değişikliği
      Scenario Outline: Updating various configuration settings
        Given the user is on the "<config_type>" settings page
        When the user selects item "<item_name>"
        And updates the parameter "<parameter>" to "<new_value>"
        And clicks "Save"
        Then the system should validate the input
        And send the update to the Backend Configuration Service
        And display a "Saved successfully" confirmation
        
        Examples:
          | config_type | item_name      | parameter  | new_value   |
          | Zone        | VR Area        | Capacity   | 15          |
          | Game        | Street Fighter | Price      | 20.00       |
          | Pricing     | Weekend Promo  | Date Range | 01-05 Oct   |
          
      # Alternatif Akış A1: Geçersiz Tarih
      Scenario: Validation of campaign dates
        Given the user is creating a new pricing campaign
        When the user sets the "End Date" before the "Start Date"
        Then the system should display a "Invalid Date Range" error
        And prevent saving the campaign
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-D4.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_d4 @testcase
Scenario: UC-D4 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Management (Zone, Game, Pricing) (UC-D4)
      As a Manager or Admin
      I want to configure zones, games, and pricing
      So that I can manage the facility operations and revenue
      
      # Basic Flow: Ayar Değişikliği
      Scenario Outline: Updating various configuration settings
        Given the user is on the "<config_type>" settings page
        When the user selects item "<item_name>"
        And updates the parameter "<parameter>" to "<new_value>"
        And clicks "Save"
        Then the system should validate the input
        And send the update to the Backend Configuration Service
        And display a "Saved successfully" confirmation
        
        Examples:
          | config_type | item_name      | parameter  | new_value   |
          | Zone        | VR Area        | Capacity   | 15          |
          | Game        | Street Fighter | Price      | 20.00       |
          | Pricing     | Weekend Promo  | Date Range | 01-05 Oct   |
          
      # Alternatif Akış A1: Geçersiz Tarih
      Scenario: Validation of campaign dates
        Given the user is creating a new pricing campaign
        When the user sets the "End Date" before the "Start Date"
        Then the system should display a "Invalid Date Range" error
        And prevent saving the campaign
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-D4.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_d4 @uml
Scenario: UC-D4 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Management (Zone, Game, Pricing) (UC-D4)
      As a Manager or Admin
      I want to configure zones, games, and pricing
      So that I can manage the facility operations and revenue
      
      # Basic Flow: Ayar Değişikliği
      Scenario Outline: Updating various configuration settings
        Given the user is on the "<config_type>" settings page
        When the user selects item "<item_name>"
        And updates the parameter "<parameter>" to "<new_value>"
        And clicks "Save"
        Then the system should validate the input
        And send the update to the Backend Configuration Service
        And display a "Saved successfully" confirmation
        
        Examples:
          | config_type | item_name      | parameter  | new_value   |
          | Zone        | VR Area        | Capacity   | 15          |
          | Game        | Street Fighter | Price      | 20.00       |
          | Pricing     | Weekend Promo  | Date Range | 01-05 Oct   |
          
      # Alternatif Akış A1: Geçersiz Tarih
      Scenario: Validation of campaign dates
        Given the user is creating a new pricing campaign
        When the user sets the "End Date" before the "Start Date"
        Then the system should display a "Invalid Date Range" error
        And prevent saving the campaign
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-D4_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-D5 – Financial Reporting and Transactions
################################################################################

@uc_d5 @requirement
Scenario: UC-D5 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Financial Reporting and Transactions (UC-D5)
      As a User with financial access
      I want to view transaction logs and generate reports
      So that I can audit the financial status
      
      # Basic Flow: Rapor Filtreleme
      Scenario: Generating a filtered financial report
        Given the user is on the "Reports" screen
        When the user selects report type "Daily Sales"
        And sets the date range to "Last 7 Days"
        And clicks "Generate"
        Then the system should retrieve records from the Backend
        And display the report in a table format
        
      # Alternatif Akış A1: Kayıt Yok
      Scenario: No records found for criteria
        When the user applies filters that yield no results
        Then the system should display a "No records found" message
        And suggest adjusting the filters
        
      # İstisna Akış I1: Veri Çok Büyük
      Scenario: Handling excessive data requests
        When the user attempts to generate a report for "Last 5 Years"
        Then the system should detect that the data set is too large
        And display a "Data range too large, please narrow your search" warning
        And prevent the database query execution
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-D5.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_d5 @testcase
Scenario: UC-D5 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Financial Reporting and Transactions (UC-D5)
      As a User with financial access
      I want to view transaction logs and generate reports
      So that I can audit the financial status
      
      # Basic Flow: Rapor Filtreleme
      Scenario: Generating a filtered financial report
        Given the user is on the "Reports" screen
        When the user selects report type "Daily Sales"
        And sets the date range to "Last 7 Days"
        And clicks "Generate"
        Then the system should retrieve records from the Backend
        And display the report in a table format
        
      # Alternatif Akış A1: Kayıt Yok
      Scenario: No records found for criteria
        When the user applies filters that yield no results
        Then the system should display a "No records found" message
        And suggest adjusting the filters
        
      # İstisna Akış I1: Veri Çok Büyük
      Scenario: Handling excessive data requests
        When the user attempts to generate a report for "Last 5 Years"
        Then the system should detect that the data set is too large
        And display a "Data range too large, please narrow your search" warning
        And prevent the database query execution
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-D5.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_d5 @uml
Scenario: UC-D5 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Financial Reporting and Transactions (UC-D5)
      As a User with financial access
      I want to view transaction logs and generate reports
      So that I can audit the financial status
      
      # Basic Flow: Rapor Filtreleme
      Scenario: Generating a filtered financial report
        Given the user is on the "Reports" screen
        When the user selects report type "Daily Sales"
        And sets the date range to "Last 7 Days"
        And clicks "Generate"
        Then the system should retrieve records from the Backend
        And display the report in a table format
        
      # Alternatif Akış A1: Kayıt Yok
      Scenario: No records found for criteria
        When the user applies filters that yield no results
        Then the system should display a "No records found" message
        And suggest adjusting the filters
        
      # İstisna Akış I1: Veri Çok Büyük
      Scenario: Handling excessive data requests
        When the user attempts to generate a report for "Last 5 Years"
        Then the system should detect that the data set is too large
        And display a "Data range too large, please narrow your search" warning
        And prevent the database query execution
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-D5_Sequence.txt"
  And The file should contain valid PlantUML code


################################################################################
# UC-D6 – Configuration Publishing and Synchronization
################################################################################

@uc_d6 @requirement
Scenario: UC-D6 Requirement Extraction
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Publishing and Synchronization (UC-D6)
      As an Admin
      I want to publish saved configurations to all devices
      So that changes take effect across the facility
      
      Background:
        Given there are pending configuration changes
        
      # Basic Flow: Başarılı Yayınlama
      Scenario: Publishing changes to the live system
        When the Admin reviews the pending changes
        And clicks the "Publish" button
        Then the Backend Distribution Service should broadcast updates to all components (Zones, Kiosks)
        And the system should display a "Configuration published successfully" message
        
      # Alternatif Akış A1: Değişiklik Yok
      Scenario: Attempting to publish with no changes
        Given there are NO pending changes
        When the Admin clicks "Publish"
        Then the system should display a "No changes to publish" info message
        
      # İstisna Akış I2: Kısmi Dağıtım Hatası
      Scenario: Handling partial distribution failures
        When the system publishes the configuration
        But the update fails for "Kiosk-05"
        Then the system should report "Publish completed with errors"
        And list "Kiosk-05" as failed
        And provide an option to "Retry Failed Units"
    """
  When AI analyzes the BDD scenario and generates system requirements
  Then The output should be saved as "Requirements_UC-D6.md"
  And The file should contain at least "1" Functional Requirement (FR)

@uc_d6 @testcase
Scenario: UC-D6 Test Case Generation
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Publishing and Synchronization (UC-D6)
      As an Admin
      I want to publish saved configurations to all devices
      So that changes take effect across the facility
      
      Background:
        Given there are pending configuration changes
        
      # Basic Flow: Başarılı Yayınlama
      Scenario: Publishing changes to the live system
        When the Admin reviews the pending changes
        And clicks the "Publish" button
        Then the Backend Distribution Service should broadcast updates to all components (Zones, Kiosks)
        And the system should display a "Configuration published successfully" message
        
      # Alternatif Akış A1: Değişiklik Yok
      Scenario: Attempting to publish with no changes
        Given there are NO pending changes
        When the Admin clicks "Publish"
        Then the system should display a "No changes to publish" info message
        
      # İstisna Akış I2: Kısmi Dağıtım Hatası
      Scenario: Handling partial distribution failures
        When the system publishes the configuration
        But the update fails for "Kiosk-05"
        Then the system should report "Publish completed with errors"
        And list "Kiosk-05" as failed
        And provide an option to "Retry Failed Units"
    """
  When AI extracts detailed test cases from the BDD scenario
  Then The output should be saved as "TestCases_UC-D6.md"
  And The file should contain at least "3" Test Cases (TC)

@uc_d6 @uml
Scenario: UC-D6 UML Diagram Generation - Sequence
  Given The BDD text to be analyzed is:
    """
    Feature: Configuration Publishing and Synchronization (UC-D6)
      As an Admin
      I want to publish saved configurations to all devices
      So that changes take effect across the facility
      
      Background:
        Given there are pending configuration changes
        
      # Basic Flow: Başarılı Yayınlama
      Scenario: Publishing changes to the live system
        When the Admin reviews the pending changes
        And clicks the "Publish" button
        Then the Backend Distribution Service should broadcast updates to all components (Zones, Kiosks)
        And the system should display a "Configuration published successfully" message
        
      # Alternatif Akış A1: Değişiklik Yok
      Scenario: Attempting to publish with no changes
        Given there are NO pending changes
        When the Admin clicks "Publish"
        Then the system should display a "No changes to publish" info message
        
      # İstisna Akış I2: Kısmi Dağıtım Hatası
      Scenario: Handling partial distribution failures
        When the system publishes the configuration
        But the update fails for "Kiosk-05"
        Then the system should report "Publish completed with errors"
        And list "Kiosk-05" as failed
        And provide an option to "Retry Failed Units"
    """
  When AI generates a "Sequence Diagram" from the BDD scenario
  Then The output should be saved as "UML_UC-D6_Sequence.txt"
  And The file should contain valid PlantUML code
