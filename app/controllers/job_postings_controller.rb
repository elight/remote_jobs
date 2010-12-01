class JobPostingsController < InheritedResources::Base
  actions :all, :except => :destroy
  respond_to :html

  filter_parameter_logging :number, :cvv

  def index
    @job_postings = JobPosting.where(:enabled => true).order("created_at DESC")
  end

  def new
    @job_posting = JobPosting.new(:category => "Development", :payment_type => "Hourly", :job_type => "Freelancer", :country => "United States")
    @credit_card = @job_posting.build_credit_card
  end

  def create
    @job_posting = JobPosting.new(params["job_posting"])

    if credit_card_charge_fails?
      flash[:error] = @failure_reason
      Rails.logger.info "HIHIHIHIHI"
      Rails.logger.info @job_posting.credit_card.month
      render :action => "new" and return
    end

    if !@job_posting.valid?
      render :action => "new" and return
    end

    credit_card = @job_posting.credit_card
    @job_posting.credit_card = nil
    if @job_posting.save
      flash[:notice] = "Posting created"
      JobPostingMailer.new_job_posting_email(@job_posting).deliver
      redirect_to job_posting_path(@job_posting)
    else
      @job_posting.credit_card = credit_card
      render :action => "new"
    end
  end

  def edit
    @job_posting = JobPosting.where(:uid => params[:uuid]).try(:first)
  end

  def update
    @job_posting = JobPosting.where(:uid => params[:job_posting][:uid]).try(:first)
    if @job_posting.update_attributes(params[:job_posting])
      flash[:notice] = "Posting updated"
      redirect_to job_posting_path(@job_posting)
    else
      render :action => "edit", :uid => @job_posting.uid
    end
  end

  # members

  def disable 
    @job_posting = JobPosting.where(:uid => params[:uuid]).try(:first)
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
      result = true
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

        # Authorize for $10 dollars (1000 cents) 
        @response = gateway.purchase(7500, credit_card)

        result = !@response.success?
          
        unless @response.success?
          @failure_reason = @response.message
          @failure_reason ||= "Sorry, but your credit card information does not appear to be valid"
          Rails.logger.debug(@response.inspect)
        end
      end
      result
    end
end
