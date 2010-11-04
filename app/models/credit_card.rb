class CreditCard < ActiveRecord::Base
  validates_presence_of :number, :month, :year, :cvv

  belongs_to :job_posting
end
