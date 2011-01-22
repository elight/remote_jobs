require 'test_helper'

Feature "Create new job" do
  
  def self.scenario_where_customer_adds_job_with(payment_type, &payment_step)
    Scenario "Customer successfully adds a new job with a valid #{payment_type}" do
      when_i_visit :root_path

      Then "it should have an https link to jobs_new" do
        page.has_selector? :xpath, "//a[@href='https://secure.localhost#{new_job_posting_path}']"
      end

      when_i_click_link "+ add"

      Given "I fill out the new job form" do
        @job_template = Factory.build(:job_posting)
        fill_in "job_posting_title", :with => @job_template.title
        choose "job_posting_category_development"
        choose "job_posting_job_type_employee"
        choose "job_posting_payment_type_salary"
        fill_in "job_posting_contract_term_length", :with => @job_template.contract_term_length
        fill_in "job_posting_description", :with => @job_template.description
        fill_in "job_posting_company_name", :with => @job_template.company_name
        fill_in "job_posting_company_url", :with => @job_template.company_url
        fill_in "job_posting_hiring_criteria", :with => @job_template.hiring_criteria
        fill_in "job_posting_how_to_apply", :with => @job_template.how_to_apply
        fill_in "job_posting_email_address", :with => @job_template.email_address

        @job_count = JobPosting.count
      end

      when_i_click_button "Preview Job"

      Then "I should have created a new JobPosting" do
        assert_equal @job_count + 1, JobPosting.count
      end

      And "it should be in the preview state" do
        @job = JobPosting.last
        assert !@job.enabled?
      end

      And "I should be in the 'secure' subdomain" do
        assert_match /\/secure\./, current_url
      end

      When "I enter valid #{payment_type}information" do
        instance_eval &payment_step
      end

      when_i_click_button "Publish Job"

      Then "I should be on the job show page" do
        save_and_open_page
        assert_equal job_posting_path(@job), current_path
      end

      And "it should be in the published state" do
        @job.reload
        assert @job.enabled?
      end
    end
  end

  scenario_where_customer_adds_job_with("credit card") do
    card = Factory.build(:credit_card)
    fill_in "job_posting_credit_card_attributes_number", :with => card.number
    select card.month.to_s, :from => "job_posting_credit_card_attributes_month"
    select card.year.to_s, :from => "job_posting_credit_card_attributes_year"
    fill_in "job_posting_credit_card_attributes_cvv", :with => card.cvv
    fill_in "job_posting_first_name", :with => @job_template.first_name
    fill_in "job_posting_last_name", :with => @job_template.last_name
    fill_in "job_posting_street_address1", :with => @job_template.street_address1
    fill_in "job_posting_street_address2", :with => @job_template.street_address2
    fill_in "job_posting_city", :with => @job_template.city
    fill_in "job_posting_state", :with => @job_template.state
    select "United States", :from => "job_posting_country"
    fill_in "job_posting_phone_number", :with => @job_template.phone_number
  end

  scenario_where_customer_adds_job_with("coupon") do
    coupon = Factory(:unused_coupon)
    fill_in "job_posting_coupon_code", :with => coupon.code
  end
end
