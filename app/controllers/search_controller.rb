class SearchController < ApplicationController
  def search
    render(:partial => "job_postings/job_posting", :collection => search_job_postings.results)
  end

  def filter
    render(:partial => "job_postings/job_posting", :collection => filtered_job_postings.results)
  end

  private

  def search_job_postings
    Sunspot.search(JobPosting) do
      fulltext params[:search]
    end
  end

  def filtered_job_postings
    Sunspot.search(JobPosting) do
      if !(params[:employee].present? && params[:freelancer].present?)
        if params[:employee].present?
          with :job_type, "Employee"
        else
          with :job_type, "Freelancer"
          with(:contract_term_length).greater_than(params[:min_term].to_i - 1)
          with(:contract_term_length).less_than(params[:max_term].to_i + 1)
        end
      end

      if !(params[:hourly].present? && params[:salary].present?)
        if params[:hourly].present?
          with :pay_type, "Hourly"
        else
          with :pay_type, "Salary"
          relation.where(:pay_type => "Salary")
        end
      end
    end
  end
end

