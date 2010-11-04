class JobPosting < ActiveRecord::Base
  CATEGORIES = {"Design" => 1, "Development" => 2, "Copywriting" => 3, "Management" => 4}

  validates_presence_of :title, :description, :contractor, :hourly, :how_to_apply, :hiring_criteria, 
                        :category, :company_name, :first_name, :last_name, :email_address, 
                        :street_address1, :city, :state, :country, :phone_number
  validate :format_of_email
  
  has_one :credit_card
  accepts_nested_attributes_for :credit_card

  def format_of_email
    unless email_address =~ /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
      errors.add(:email_address, "Email address is invalid")
    end
  end

  def to_param
    "#{id}_#{title.underscore}"
  end

  def category_label
    JobPosting::CATEGORIES.find { |k, v| v == self.category }.first
  end
end
