@theme @theme_boost_campus @theme_boost_campus_info_banner_settings
Feature: Configuring the theme_boost_campus plugin for the "Info banner Settings" tab
  In order to use the features
  As admin
  I need to be able to configure the theme Boost Campus plugin

  Background:
    Given the following "users" exist:
      | username |
      | teacher1 |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
    # There is a nasty bug with Behat-testing this theme that the footer is not displayed until the settings
    # of the theme are stored manually. It seems not to be sufficient to just rely on the default settings being
    # stored during the installation of the theme. Until we find the root of this bug, we circumvent it by setting the
    # brand color manually and within this process making sure that all settings are really stored to the database.
    And I log in as "admin"
    And I navigate to "Appearance > Boost Campus" in site administration
    And I click on "General settings" "link"
    And I set the field "id_s_theme_boost_campus_brandcolor" to "#7a99ac"
    And I press "Save changes"
    And I log out

  Scenario: Display perpetual info banner on all available pages
    Given the following config values are set as admin:
      | config                         | value                    | plugin             |
      | perpetualinfobannerenable      | 1                        | theme_boost_campus |
      | perpetualinfobannercontent     | "This is a test content" | theme_boost_campus |
      | perpetualinfobannerpagestoshow | mydashboard,course,login | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    When I am on "Course 1" course homepage
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    When I log out
    And I click on "Log in" "link"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"

  Scenario: Display perpetual info banner only on one available page
    Given the following config values are set as admin:
      | config                         | value                    | plugin             |
      | perpetualinfobannerenable      | 1                        | theme_boost_campus |
      | perpetualinfobannercontent     | "This is a test content" | theme_boost_campus |
      | perpetualinfobannerpagestoshow | mydashboard              | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    When I am on "Course 1" course homepage
    Then I should not see "This is a test content"
    When I log out
    And I click on "Log in" "link"
    Then I should not see "This is a test content"

  Scenario: Display perpetual info with the different bootstrap color classes
    Given the following config values are set as admin:
      | config                         | value                    | plugin             |
      | perpetualinfobannerenable      | 1                        | theme_boost_campus |
      | perpetualinfobannercontent     | "This is a test content" | theme_boost_campus |
      | perpetualinfobannerpagestoshow | mydashboard              | theme_boost_campus |
      | perpetualinfobannercssclass    | primary                  | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    And the "class" attribute of "#themeboostcampusperpinfobanner" "css_element" should contain "primary"
    And I log out
    Given the following config values are set as admin:
      | config                      | value     | plugin             |
      | perpetualinfobannercssclass | secondary | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    And the "class" attribute of "#themeboostcampusperpinfobanner" "css_element" should contain "secondary"
    And I log out
    Given the following config values are set as admin:
      | config                      | value   | plugin             |
      | perpetualinfobannercssclass | success | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    And the "class" attribute of "#themeboostcampusperpinfobanner" "css_element" should contain "success"
    And I log out
    Given the following config values are set as admin:
      | config                      | value  | plugin             |
      | perpetualinfobannercssclass | danger | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    And the "class" attribute of "#themeboostcampusperpinfobanner" "css_element" should contain "danger"
    And I log out
    Given the following config values are set as admin:
      | config                      | value   | plugin             |
      | perpetualinfobannercssclass | warning | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    And the "class" attribute of "#themeboostcampusperpinfobanner" "css_element" should contain "warning"
    And I log out
    Given the following config values are set as admin:
      | config                      | value | plugin             |
      | perpetualinfobannercssclass | info  | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    And the "class" attribute of "#themeboostcampusperpinfobanner" "css_element" should contain "info"
    And I log out
    Given the following config values are set as admin:
      | config                      | value | plugin             |
      | perpetualinfobannercssclass | light | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    And the "class" attribute of "#themeboostcampusperpinfobanner" "css_element" should contain "light"
    And I log out
    Given the following config values are set as admin:
      | config                      | value | plugin             |
      | perpetualinfobannercssclass | dark  | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
    And the "class" attribute of "#themeboostcampusperpinfobanner" "css_element" should contain "dark"
    And I log out

  Scenario: Save perpetual content but do not enable the info banner setting at all.
    Given the following config values are set as admin:
      | config                         | value                    | plugin             |
      | perpetualinfobannerenable      | 0                        | theme_boost_campus |
      | perpetualinfobannercontent     | "This is a test content" | theme_boost_campus |
      | perpetualinfobannerpagestoshow | mydashboard              | theme_boost_campus |
    When I log in as "teacher1"
    Then I should not see "This is a test content"

#  # This does not work currently
#  # The clicking away of the Bootstrap alert leads to this error - see MDL-69086.
#  # TODO: Reevaluate when MDL-69086 is fixed.
#  @javascript @_alert
#  Scenario: Enable setting "Perpetual info banner dismissible"
#    Given the following config values are set as admin:
#      | config                         | value                    | plugin             |
#      | perpetualinfobannerenable      | 1                        | theme_boost_campus |
#      | perpetualinfobannercontent     | "This is a test content" | theme_boost_campus |
#      | perpetualinfobannerpagestoshow | mydashboard              | theme_boost_campus |
#      | perpetualinfobannerdismissible | 1                        | theme_boost_campus |
#    When I log in as "teacher1"
#    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
#    When I click on "#themeboostcampusperpinfobannerclosebutton" "css_element"
#    Then I should not see "This is a test content"
#
#  # This does not work currently
#  # The clicking away of the Bootstrap alert leads to this error - see MDL-69086.
#  # TODO: Reevaluate when MDL-69086 is fixed.
#  # This setting depends on the setting "Info banner dismissible"
#  @javascript @_alert
#  Scenario: Enable setting "Confirmation dialogue"
#    Given the following config values are set as admin:
#      | config                             | value                    | plugin             |
#      | perpetualinfobannerenable          | 1                        | theme_boost_campus |
#      | perpetualinfobannercontent         | "This is a test content" | theme_boost_campus |
#      | perpetualinfobannerpagestoshow     | mydashboard              | theme_boost_campus |
#      | perpetualinfobannerdismissible     | 1                        | theme_boost_campus |
#      | perpetualinfobannerconfirmdialogue | 1                        | theme_boost_campus |
#    When I log in as "teacher1"
#    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
#    When I click on "#themeboostcampusperpinfobannerclosebutton" "css_element"
#    Then I should see "Confirmation" in the ".modal-title" "css_element"
#    When I click on "Cancel" "button" in the ".modal-footer" "css_element"
#    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
#    When I click on "#themeboostcampusperpinfobannerclosebutton" "css_element"
#    Then I should see "Confirmation" in the ".modal-title" "css_element"
#    When I click on "Yes, close!" "button" in the ".modal-footer" "css_element"
#    Then I should not see "This is a test content"
#
#  # This does not work currently
#  # The clicking away of the Bootstrap alert leads to this error - see MDL-69086.
#  # TODO: Reevaluate when MDL-69086 is fixed.
#  # This setting depends on the setting "Info banner dismissible"
#  @javascript @_alert
#  Scenario: Enable setting "Reset visibility for perpetual info banner"
#    Given the following config values are set as admin:
#      | config                                 | value                    | plugin             |
#      | perpetualinfobannerenable              | 1                        | theme_boost_campus |
#      | perpetualinfobannercontent             | "This is a test content" | theme_boost_campus |
#      | perpetualinfobannerpagestoshow         | mydashboard              | theme_boost_campus |
#      | perpetualinfobannerdismissible         | 1                        | theme_boost_campus |
#    When I log in as "teacher1"
#    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
#    When I click on "#themeboostcampusperpinfobannerclosebutton" "css_element"
#    Then I should not see "This is a test content"
#    And I log out
#    When I log in as "admin"
#    And I navigate to "Appearance > Boost Campus" in site administration
#    And I click on "Additional Layout Settings" "link"
#    And I click on "Reset visibility" "checkbox"
#    And I press "Save Changes"
#    Then I should see "Success! All info banner instances are visible again."
#    And I log out
#    When I log in as "teacher 1"
#    Then I should see "This is a test content" in the "#themeboostcampusperpinfobanner" "css_element"
