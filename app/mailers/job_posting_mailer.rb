class JobPostingMailer < ActionMailer::Base
  default :from => "notification@remote.jobs"

  def new_job_posting_email(job_posting)
    @title = job_posting.title
    @url = "http://remote.jobs/edit/#{job_posting.uid}"
    mail :to => job_posting.email_address,
         :subject => "Your job has been posted"
  end
end
