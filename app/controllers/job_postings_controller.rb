class JobPostingsController < InheritedResources::Base

  actions :all, :except => :destroy
  respond_to :html

  def index
    @job_postings = JobPosting.where(:enabled => true).order("created_at DESC").paginate(:page => params[:page], :per_page => 16)
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def new
    @job_posting = JobPosting.new(:category => "Development", :payment_type => "Hourly", :job_type => "Freelancer", :country => "United States")
  end

  def create
    @job_posting = JobPosting.new(params["job_posting"])

    if @job_posting.save
      JobPostingMailer.new_job_posting_email(@job_posting).deliver
      redirect_to preview_path(@job_posting.uid)
    else
      render :action => "new" and return
    end
  end
  
  def preview
    @job_posting = JobPosting.find_by_uid(params[:uid])
    #@job_posting.build_credit_card
  end

  def publish
    @job_posting = JobPosting.find_by_uid(params[:uid])
    if @job_posting.nil?
      @job_posting.errors.add(:job_posting, "Sorry but we couldn't find your job posting with id #{params[:uid]}")
      redirect_to root_path and return
    elsif @job_posting.enabled?
      @job_posting.errors.add(:job_posting, "Your job posting has already been published")
      redirect_to root_path and return
    end

    handle_successful_job_creation
  end

  def edit
    @job_posting = JobPosting.where(:uid => params[:uid]).try(:first)
  end

  def update
    @job_posting = JobPosting.where(:uid => params[:job_posting][:uid]).try(:first)
    if @job_posting.update_attributes(params[:job_posting])
      flash[:notice] = "Job updated"
      redirect_to preview_path(@job_posting.uid)
    else
      render :action => "edit", :uid => @job_posting.uid
    end
  end

  def disable 
    @job_posting = JobPosting.where(:uid => params[:uid]).try(:first)
    @job_posting.try(:disable!)
    flash[:notice] = "Your job posting seeking a '#{@job_posting.title}' has been closed"
    redirect_to job_postings_path
  end
  
  private
  
    def handle_filters
      ["freelancer", "employee"].each do |filter|
        @job_postings = @job_postings.where("job_type <> ?", filter.capitalize) if session["hide_#{filter}".to_sym]
      end
      ["salary", "hourly"].each do |filter|
        @job_postings = @job_postings.where("payment_type <> ?", filter.capitalize) if session["hide_#{filter}".to_sym]
      end
    end

    def handle_successful_job_creation
      @job_posting.update_attribute(:enabled, true)
      flash[:notice] = "Yay! Your job is now public."
      JobPostingMailer.job_posting_receipt(@job_posting).deliver
      redirect_to job_posting_path(@job_posting)
    end
end
