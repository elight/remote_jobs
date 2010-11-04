class JobPostingsController < InheritedResources::Base
  actions :all, :except => :destroy
  respond_to :html

  def index
    @job_postings = JobPosting.order("created_at DESC")
  end

  def new
    @job_posting = JobPosting.new(:category => "Design", :payment_type => "Hourly", :job_type => "Freelancer")
    @credit_card = @job_posting.build_credit_card
  end

  def create
    @credit_card = nil
    cc_params = params["job_posting"].delete "credit_card"
    @job_posting = JobPosting.new_with_uuid(params["job_posting"])
    if @job_posting.save
      flash[:notice] = "Posting created"
      JobPostingMailer.new_job_posting_email(@job_posting).deliver
      redirect_to job_posting_path(@job_posting)
    else
      @credit_card = CreditCard.new(cc_params)
      render :action => "new"
    end
  end
end
