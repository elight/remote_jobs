class SearchController < ApplicationController

  def filter
    begin
      #store_filters_in_session
      render(:partial => "job_postings/job_posting", :collection => filtered_job_postings)
    rescue Exception => e
      render :text => e
    end
  end

  private
  
  def filtered_job_postings
    job_postings = JobPosting.where(:enabled => true).order("created_at DESC")
    
    categories = []
    ["design", "development", "copywriting", "management"].each do |category|
      categories << "'#{category.capitalize}'" if params[category.to_sym].present?
    end
    job_postings = job_postings.where("category IN (#{categories.join(",")})") unless categories.empty?
    
    job_types = []
    ["freelancer", "employee"].each do |job_type|
      job_types << "'#{job_type.capitalize}'" if params[job_type.to_sym].present?
    end
    job_postings = job_postings.where("job_type IN (#{job_types.join(",")})") unless job_types.empty?
    
    payment_types = []
    ["hourly", "salary"].each do |payment_type|
      payment_types << "'#{payment_type.capitalize}'" if params[payment_type.to_sym].present?
    end
    job_postings = job_postings.where("payment_type IN (#{payment_types.join(",")})") unless payment_types.empty?
    
    job_postings = job_postings.where("UPPER(title) LIKE ?", "%#{params[:search].upcase}%") unless params[:search].blank?

    return job_postings
  end

  def filtered_job_postings_with_solr
    Sunspot.search(JobPosting) do
      fulltext params[:search] if params[:search].present?
      
      any_of do
        ["design", "development", "copywriting", "management"].each do |category|
          with :category, category.capitalize if params[category.to_sym].present?
        end
      end
      
      any_of do
        ["freelancer", "employee"].each do |job_type|
          with :job_type, job_type.capitalize if params[job_type.to_sym].present?
        end
      end
      
      any_of do
        ["hourly", "salary"].each do |payment_type|
          with :payment_type, payment_type.capitalize if params[payment_type.to_sym].present?
        end
      end
      
      order_by :created_at, :desc
    end
  end
end

