class SearchController < ApplicationController
  def search
    render(:partial => "job_postings/job_posting", :collection => search_job_postings.results)
  end

  def filter
    begin
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

  def filtered_job_postings
    Sunspot.search(JobPosting) do
      if params[:employee].present?
        with :job_type, "Employee"
      end
      if params[:freelancer].present?
        with :job_type, "Freelancer"
        with(:contract_term_length).greater_than(params[:min_term].to_i - 1)
        with(:contract_term_length).less_than(params[:max_term].to_i + 1)
      end
      if !(params[:employee].present? || params[:freelancer].present?)
        msg = "WTF? You need employee or freelancer"
        Rails.logger.error(msg)
        raise msg
      end

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
  end
end

