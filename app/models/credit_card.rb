class CreditCard < ActiveRecord::Base
  validates_presence_of :number, :month, :year, :cvv

  belongs_to :job_posting
  
  def copy_values_from(active_merchant_credit_card)
    self.number = active_merchant_credit_card.number
    self.month = active_merchant_credit_card.month
    self.year = active_merchant_credit_card.year
    self.cvv = active_merchant_credit_card.verification_value
  end
end