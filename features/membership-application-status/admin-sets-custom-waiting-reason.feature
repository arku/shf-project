Feature: Admin sets or enters the reason they are waiting for info from a user
  As an admin
  so that SHF can talk with the user specifically about why they are waiting and know how long they might need to wait,
  I need to set the reason why SHF is waiting
  and if the reason is not available from a list,
  I need to be able to type in text that describes the situation

  PT: https://www.pivotaltracker.com/story/show/143810729

  Background:
    Given the following users exists
      | email                                  | admin |
      | anna_waiting_for_info@nosnarkybarky.se |       |
      | admin@shf.com                          | true  |

    Given the following business categories exist
      | name  | description           |
      | rehab | physcial rehabitation |

    Given the following regions exist:
      | name      |
      | Stockholm |

    Given the following companies exist:
      | name                 | company_number | email                 | region    |
      | No More Snarky Barky | 5560360793     | snarky@snarkybarky.se | Stockholm |


    And the following applications exist:
      | first_name  | user_email                             | company_number | category_name | state                 |
      | AnnaWaiting | anna_waiting_for_info@nosnarkybarky.se | 5560360793     | rehab         | waiting_for_applicant |


    And the following member app waiting reasons exist
      | name_sv                  | description_sv            | name_en                  | description_en                             | is_custom |
      | need doc                 | need doc                  | need documentation       | need more documents proving qualifications | false     |
      | waiting for payment      | still waiting for payment | waiting for payment      | still waiting for payment                  | false     |




    And I am logged in as "admin@shf.com"


  @javascript @admin
  Scenario: Admin selects 'need more documentation' as the reason SHF is waiting_for_applicant
    Given I am on "AnnaWaiting" application page
    When I set "member_app_waiting_reasons" to "need doc"
    Then "member_app_waiting_reasons" should have "need doc" selected
    And I am on the list applications page
    And I am on "AnnaWaiting" application page
    Then "member_app_waiting_reasons" should have "need doc" selected

  @javascript @admin
  Scenario: Admin selects 'waiting for payment' as the reason SHF is waiting_for_applicant
    Given I am on "AnnaWaiting" application page
    When I set "member_app_waiting_reasons" to "waiting for payment"
    And I am on the list applications page
    And I am on "AnnaWaiting" application page
    And "member_app_waiting_reasons" should have "waiting for payment" selected


  @javascript @admin
  Scenario: Admin selects 'other' and enters text as the reason SHF is waiting_for_applicant
    Given I am on "AnnaWaiting" application page
    When I set "member_app_waiting_reasons" to t("admin_only.member_app_waiting_reasons.other_custom_reason")
    When I fill in "custom_reason_text" with "This is my reason"
    And I press enter in "custom_reason_text"
    And I am on the list applications page
    And I am on "AnnaWaiting" application page

    And I should see t("membership_applications.need_info.other_reason_label")
    And the t("membership_applications.need_info.other_reason_label") field should be set to "This is my reason"
    And "member_app_waiting_reasons" should have t("admin_only.member_app_waiting_reasons.other_custom_reason") selected


  @javascript @admin
  Scenario: Admin selects 'other' and fills in custom text but then changes reason to something else
    Given I am on "AnnaWaiting" application page
    When I set "member_app_waiting_reasons" to t("admin_only.member_app_waiting_reasons.other_custom_reason")
    And I fill in "custom_reason_text" with "This is my reason"
    And I press enter in "custom_reason_text"
    And I wait for all ajax requests to complete
    And I set "member_app_waiting_reasons" to "waiting for payment"
    And I am on the list applications page
    And I am on "AnnaWaiting" application page
    And "member_app_waiting_reasons" should have "waiting for payment" selected


  @javascript @admin
  Scenario: When selected reason is not 'custom other,' the custom text is saved as blank (empty string)
    Given I am on "AnnaWaiting" application page

    When I set "member_app_waiting_reasons" to t("admin_only.member_app_waiting_reasons.other_custom_reason")
    And I fill in "custom_reason_text" with "This is my reason"
    And I press enter in "custom_reason_text"
    And I set "member_app_waiting_reasons" to "need doc"
    # change back so the custom reason field shows. it should be blank
    And I set "member_app_waiting_reasons" to t("admin_only.member_app_waiting_reasons.other_custom_reason")
    Then I should not see "This is my reason"


  @javascript @member
  Scenario: owner cannot see the fields for changing the reason
    Given I am logged in as "anna_waiting_for_info@nosnarkybarky.se"
    And I am on the application page for "AnnaWaiting"
    Then I should not see t("membership_applications.need_info.reason_title")
