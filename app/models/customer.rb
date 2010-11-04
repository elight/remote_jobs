class Customer < ActiveRecord::Base
  has_many :job_postings

  validates_presence_of :first_name, :last_name, :email_address, :street_address1, :city, :state, :country, :phone_number
  validate :format_of_email
  
  def format_of_email
    unless email_address =~ /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
      errors.add(:email_addres
    end
  end
end
