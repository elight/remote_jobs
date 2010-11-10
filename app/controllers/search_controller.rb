class SearchController < ApplicationController
  def search
    render(:partial => "job_postings/job_posting", :collection => search_job_postings.results)
  end

  def filter
    begin
      store_filters_in_session
      render(:partial => "job_postings/job_posting", :collection => filtered_job_postings.results)
    rescue Exception => e
      render :text => e
    end
  end

  private

  def search_job_postings
    Sunspot.search(JobPosting) do
      fulltext params[:search]
    end
  end
  
  def store_filters_in_session
    ["freelancer", "employee", "hourly", "salary"].each do |filter|
      session["hide_#{filter}".to_sym] = !params[filter.to_sym].present?
    end
  end

  def filtered_job_postings
    Sunspot.search(JobPosting) do
      if params[:employee].present? && params[:freelancer].present?
        any_of do
          with :job_type, "Employee"
          all_of do
            with :job_type, "Freelancer"
            unless params[:min_term].to_i == 0
              with(:contract_term_length).greater_than(params[:min_term].to_i)
            end
            unless params[:max_term].to_i == 25
              with(:contract_term_length).less_than(params[:max_term].to_i)
            end
          end
        end
      else
        if params[:employee].present? && params[:freelancer].blank?
          with :job_type, "Employee"
        end
        if params[:freelancer].present? && params[:employee].blank?
          all_of do
            with :job_type, "Freelancer"
            unless params[:min_term].to_i == 0
              with(:contract_term_length).greater_than(params[:min_term].to_i)
            end
            unless params[:max_term].to_i == 25
              with(:contract_term_length).less_than(params[:max_term].to_i)
            end
          end
        end
        if !(params[:employee].present? || params[:freelancer].present?)
          msg = "WTF? You need employee or freelancer"
          Rails.logger.error(msg)
          raise msg
        end
      end

      if params[:hourly].present? && params[:salary].present?
        any_of do
          with :payment_type, "Hourly"
          with :payment_type, "Salary"
        end
      else
        if params[:hourly].present?
          with :payment_type, "Hourly"
        end
        if params[:salary].present?
          with :payment_type, "Salary"
        end
        if !(params[:hourly].present? || params[:salary].present?)
          msg = "WTF? You need hourly or salary"
          Rails.logger.error(msg)
          raise msg
        end
      end
      
      if params[:category].present?
        with :category, params[:category].capitalize
      end
    end
  end
end

