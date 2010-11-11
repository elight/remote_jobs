class SearchController < ApplicationController

  def filter
    begin
      #store_filters_in_session
      render(:partial => "job_postings/job_posting", :collection => filtered_job_postings.results)
    rescue Exception => e
      render :text => e
    end
  end

  private

  def filtered_job_postings
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

