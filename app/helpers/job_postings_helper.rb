require 'maruku'

module JobPostingsHelper
  def term_for(job_posting)
    case job_posting.contract_term_length
    when nil:
      ""
    when "":
      ""
    when 0:
      "<1 mo."
    when 25:
      "indefinite"
    else
      job_posting.contract_term_length
    end
  end

  def created_at_for(job_posting)
    created_date = Date.parse job_posting.created_at.to_s
    if created_date === Date.today
      date = "Today"
    elsif created_date === Date.yesterday
      date = "Yesterday"
    else
      date = job_posting.created_at.strftime("%b %d").gsub(/\b0/, "")
    end
    date
  end

  def show_term_for(job_posting)
    term = job_posting.contract_term_length
    return "None specified" if term.blank?
    term
  end

  def render_markdown_to_html(markdown)
    doc = Maruku.new(markdown)
    doc.to_html
  end
end
