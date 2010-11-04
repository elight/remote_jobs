class JobPosting < ActiveRecord::Base
  validates_presence_of :title, :description, :contractor, :hourly, :how_to_apply, :hiring_criteria, 
                        :category, :company_name, :first_name, :last_name, :email_address, 
                        :street_address1, :city, :state, :country, :phone_number
  validate :format_of_email
  
  has_one :credit_card
  accepts_nested_attributes_for :credit_card

  
  def format_of_email
    unless email_address =~ /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
      errors.add(:email_addres, "Email address is invalid")
    end
  end
end
