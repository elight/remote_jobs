class Coupon < ActiveRecord::Base
  belongs_to :job_posting

  validates_presence_of :code

  before_validation_on_create do
    self.code = UUID.new.generate(:compact)
  end
end
