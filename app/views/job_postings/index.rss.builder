xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Remote Jobs"
    xml.description "A listing of jobs for remote designers, developers, and more."
    xml.link job_postings_url

    for job in @job_postings
      xml.item do
        xml.title job.title
        xml.description job.description
        xml.pubDate job.created_at.to_s(:rfc822)
        xml.link job_posting_url(job)
        xml.guid job_posting_url(job)
      end
    end
  end
end