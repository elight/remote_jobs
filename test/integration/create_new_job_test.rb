require 'test_helper'

Feature "Create new job" do
  Scenario "Customer successfully adds a new job with a valid credit card" do
    when_i_visit :new_job_posting

    Then "I should be in the 'secure' subdomain" do
      assert_match /\/secure\./, current_path
    end

    And "my connection should use SSL" do
      assert_match /^https/, current_path
    end

    Given "I fill out the new job form" do
      save_and_open_page
    end
    And "enter valid credit card information"
    when_i_click_button "Preview Job"
    Then "I should be on the job preview page"
  end

  Scenario "Customer successfully adds a new job with a valid coupon code" 
end
