class AddCustomerIdToJobPosting < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :customer_id, :integer
  end

  def self.down
    remove_column :job_postings, :customer_id
  end
end
