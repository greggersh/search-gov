Feature: User sessions

  @javascript
  Scenario: Already logged-in user visits login page
    Given I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    When I go to the login page
    Then I should see "Contact Information"
    When I sign out
    Then I should be on the login page

  Scenario: User has trouble logging in
    Given I am on the login page
    And I fill in the following:
      | Email    | not@valid.gov |
      | Password | fail          |
    And I press "Login"
    Then I should see "Email is not valid"

  Scenario: Affiliate admin should be on the site home page upon successful login
    Given I am on the login page
    Then I should see the browser page titled "DigitalGov Search Login"
    And I fill in the following:
      | Email    | affiliate_admin@fixtures.org |
      | Password | admin                        |
    And I press "Login"
    Then I should be on the new site page

  Scenario: Affiliate manager should be on the site home page upon successful login
    Given I am on the login page
    And I fill in the following:
      | Email    | affiliate_manager@fixtures.org |
      | Password | admin                          |
    And I press "Login"
    Then I should be on the gobiernousa's Dashboard page

  Scenario: Affiliate manager with not approved status should not be able to login
    Given I am on the login page
    And I fill in the following:
      | Email    | affiliate_manager_with_not_approved_status@fixtures.org |
      | Password | admin                                                   |
    And I press "Login"
    And I should not see "Admin Center"
