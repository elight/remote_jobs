require 'maruku'

module JobPostingsHelper
  def term_for(job_posting)
    case job_posting.contract_term_length
    when nil:
      ""
    when 0:
      "< 1m"
    when 25:
      "indefinite"
    else
      "#{job_posting.contract_term_length}m"
    end
  end

  def created_at_for(job_posting)
    created_date = Date.parse job_posting.created_at.to_s
    if created_date === Date.today
      "Today"
    elsif created_date === Date.yesterday
      "Yesterday"
    else
      job_posting.created_at.strftime("%m/%d/%Y")
    end
  end

  def show_term_for(job_posting)
    term = term_for job_posting
    return "None specified" if term.blank?
    term
  end

  def render_markdown_to_html(markdown)
    doc = Maruku.new(markdown)
    doc.to_html
  end
end
