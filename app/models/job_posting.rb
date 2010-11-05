class JobPosting < ActiveRecord::Base
  searchable do
    text    :title, :boost => 2.0, :stored => true
    text    :description
    text    :hiring_criteria
  end

  CATEGORIES = %w[Design Development Copywriting Management]

  validates_presence_of :title, :description, :job_type, :payment_type, :how_to_apply, :hiring_criteria, 
                        :category, :company_name, :first_name, :last_name, :email_address, 
                        :street_address1, :city, :state, :country, :phone_number, :uid
  validate :format_of_email
  
  has_one :credit_card
  accepts_nested_attributes_for :credit_card

  def self.new_with_uuid(args = {})
    JobPosting.new(args).tap do |jp|
      jp.uid = UUID.new.generate
    end
  end

  def format_of_email
    unless email_address =~ /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
      errors.add(:email_address, "Email address is invalid")
    end
  end

  def to_param
    "#{id}_#{title.gsub(' ', '_')}"
  end

  def disable!
    self.enabled = false
    self.save!
  end
end
