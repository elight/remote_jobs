class JobPostingsController < InheritedResources::Base
  include SslRequirement

  ssl_required :new, :create if RAILS_ENV == "production"

  actions :all, :except => :destroy
  respond_to :html

  def index
    @job_postings = JobPosting.where(:enabled => true).order("created_at DESC")
  end

  def new
    @job_posting = JobPosting.new(:category => "Development", :payment_type => "Hourly", :job_type => "Freelancer", :country => "United States")
  end

  def create
    @job_posting = JobPosting.new(params["job_posting"])

    if @job_posting.save
      JobPostingMailer.new_job_posting_email(@job_posting).deliver
      redirect_to preview_path(@job_posting.uid, :only_path => false, :host => "secure.#{request.host}", :protocol => "https")
    else
      render :action => "new" and return
    end
  end
  
  def preview
    @job_posting = JobPosting.find_by_uid(params[:uid])
    @job_posting.build_credit_card
  end

  def publish
    @job_posting = JobPosting.find_by_uid(params[:uid])
    if @job_posting.nil? 
      flash[:error] = "Sorry but we couldn't find your job posting with id #{params[:uid]}"
      redirect_to root_path and return
    elsif @job_posting.enabled?
      flash[:error] = "Your job posting has already been published"
      redirect_to root_path and return
    end

    coupon_code = params[:job_posting][:coupon_code]
    if coupon_code.present?
      coupon = Coupon.find_by_code(coupon_code)
      if coupon.nil?
        flash[:error] = "Sorry but we couldn't find a coupon with code '#{coupon_code}'"
        render :action => :preview and return
      elsif coupon.job_posting_id
        flash[:error] = "Sorry but coupon code '#{coupon_code}' has already been used"
        render :action => :preview and return
      end
      @job_posting.coupon = coupon
      handle_successful_job_creation and return
    end

    # this builds the nested credit card object as well
    @job_posting.attributes = params[:job_posting]
    
    if @job_posting.credit_card.nil?
      flash[:error] = "We appear to be missing your credit card details. If this problem persists, please contact us at help@remote.jobs"
      render :action => :preview and return
    end

    unless @job_posting.valid?
      render :action => :preview and return
    end

    if credit_card_charge_fails?
      @job_posting.errors.add(:base, @failure_reason) if @failure_reason.is_a?(String)
      render :action => :preview and return
    end
    
    # we have to nil this out because update_attribute saves the credit card (dirty attributes)
    @job_posting.credit_card = nil

    handle_successful_job_creation
  end

  def edit
    @job_posting = JobPosting.where(:uid => params[:uid]).try(:first)
  end

  def update
    @job_posting = JobPosting.where(:uid => params[:job_posting][:uid]).try(:first)
    if @job_posting.update_attributes(params[:job_posting])
      flash[:notice] = "Job updated"
      redirect_to job_posting_path(@job_posting)
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

    def credit_card_charge_fails?
      fails = true
      temp_card = @job_posting.credit_card
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :number     => temp_card.number,
        :month      => temp_card.month,
        :year       => temp_card.year,
        :first_name => @job_posting.first_name,
        :last_name  => @job_posting.last_name,
        :verification_value  => temp_card.cvv
      )

      if credit_card.valid?
        # Create a gateway object to the TrustCommerce service
        gateway = ActiveMerchant::Billing::BraintreeGateway.new(
          :merchant_id => ENV["BRAINTREE_MERCHANT"],
          :public_key => ENV["BRAINTREE_PUBLIC"],
          :private_key => ENV["BRAINTREE_PRIVATE"]
        )

        # Authorize for $75 dollars (7500 cents) 
        @response = gateway.purchase(7500, credit_card)

        fails = !@response.success?
          
        if fails
          @failure_reason = @response.message
          @failure_reason ||= "Sorry, but your credit card information does not appear to be valid."
        end
      else
        @job_posting.errors.add(:base, credit_card.errors.full_messages)
      end
      
      fails
    end

    def handle_successful_job_creation
      @job_posting.update_attribute(:enabled, true)
      flash[:notice] = "Yay! Your job is now public."
      JobPostingMailer.job_posting_receipt(@job_posting).deliver
      redirect_to job_posting_path(@job_posting)
    end
end
