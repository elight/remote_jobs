class JobPostingMailer < ActionMailer::Base
  default :from => "Remote Jobs <notification@remote-jobs.com>"

  def new_job_posting_email(job_posting)
    @title = job_posting.title
    @url = "http://remote-jobs.com/edit/#{job_posting.uid}"
    mail :to => job_posting.email_address,
         :subject => "[Remote Jobs] Your job has been created"
  end
  
  def job_posting_receipt(job_posting)
    @title = job_posting.title
    @show_url = "http://remote-jobs.com/jobs/#{job_posting.to_param}"
    @edit_url = "http://remote-jobs.com/edit/#{job_posting.uid}"
    @did_use_coupon = job_posting.coupon.present?
    mail :to => job_posting.email_address,
         :subject => "[Remote Jobs] Your receipt"
  end
end
