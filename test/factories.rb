Factory.define :job_posting do |j|
  j.sequence(:title)      { |n| "Uncle Fucker #{n}" }
  j.description           "Duh"
  j.job_type              "Employee"
  j.payment_type          "Salary"
  j.how_to_apply          "Fuck someone's uncle"
  j.hiring_criteria       "Experience fucking uncles"
  j.category              "Management"
  j.company_name          "Uncle Fuckers R Us"
  j.email_address         "somedumbfucker@unclefuckersr.us"
  j.first_name            "Some Dumb"
  j.last_name             "Fucker"
  j.street_address1       "1 Dumb Fuck Way"
  j.city                  "Fuck You"
  j.state                 "DE"
  j.zipcode               "12345"
  j.country               "United States"
  j.phone_number          "555-555-5555"
end

Factory.define :credit_card do |c|
  c.number                "5105105105105100"
  c.month                 "12"
  c.year                  { (Date.today.year + 10).to_s }
  c.cvv                   "123"
end

Factory.define(:coupon) {}
Factory.define(:unused_coupon, :parent => :coupon) {}
Factory.define(:used_coupon, :parent => :unused_coupon) do |c|
  c.job_posting           { Factory(:job_posting) }
end
