class JobPostingsController < ApplicationController
  def new
    @job_posting = JobPosting.new
    @credit_card = @job_posting.build_credit_card
  end

  def create
    @credit_card = nil
    @cc_params = params["job_posting"].delete "credit_card"
    @job_posting = JobPosting.new(params["job_posting"])
    @job_posting.save!
  end
end
