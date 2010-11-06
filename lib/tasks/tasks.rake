namespace :rj do
  
  desc "Insert fake jobs"
  task :insert_jobs => :environment do
    JobPosting.create(:title => "Senior Web Designer",
      :description => "Blahbedy blah",
      :job_type => "Freelancer",
      :payment_type => "Hourly",
      :how_to_apply => "Go to our site",
      :hiring_criteria => "Do some stuff",
      :category => "Design",
      :company_name => "Tech Stuff.biz",
      :first_name => "Hugh",
      :last_name => "Mungus",
      :email_address => "a@a.com",
      :street_address1 => "1234 Road St",
      :city => "Honolulu",
      :state => "HI",
      :country => "United States",
      :phone_number => "555-555-5555")
  end
  
end