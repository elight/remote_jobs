class JobPostingsController < InheritedResources::Base
  actions :all, :except => :destroy
  respond_to :html

  def index
    @job_postings = JobPosting.order("created_at DESC")
  end

  def new
    @job_posting = JobPosting.new(:category => 1, :contractor => true, :hourly => true)
    @credit_card = @job_posting.build_credit_card
  end

  def create
    @credit_card = nil
    cc_params = params["job_posting"].delete "credit_card"
    @job_posting = JobPosting.new(params["job_posting"])
    if @job_posting.save
      flash[:notice] = "Posting created"
      redirect_to :action => "index"
    else
      @credit_card = CreditCard.new(cc_params)
      render :action => "new"
    end
  end
end
