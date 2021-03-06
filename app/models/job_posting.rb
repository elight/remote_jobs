class JobPosting < ActiveRecord::Base
  default_scope :order => "created_at DESC"

  CATEGORIES = %w[Design Development Copywriting Management]

  validates_presence_of :title, :description, :job_type, :payment_type, :how_to_apply, :hiring_criteria, 
                        :category, :company_name, :email_address
  #validates_presence_of :first_name, :last_name,  :street_address1, :city, :state, :zipcode,
  #                      :country, :phone_number, :if => Proc.new { |p| p.should_validate_address }
  validates_format_of :email_address, :with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  
  #has_one :credit_card
  #has_one :coupon
  #attr_accessor :coupon_code, :should_validate_address
  #accepts_nested_attributes_for :credit_card
  
  before_create :set_uuid
  
  scope :design, where(:category => "Design")
  scope :development, where(:category => "Development")
  scope :copywriting, where(:category => "Copywriting")
  scope :management, where(:category => "Management")

  def to_param
    "#{id}_#{title.gsub(/[^\d\w]/, '_')}"
  end

  def disable!
    self.enabled = false
    self.save!
  end
  
  private
  
    def set_uuid
      self.uid = UUID.new.generate(:compact)
    end
end
