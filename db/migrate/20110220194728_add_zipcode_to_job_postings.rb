class AddZipcodeToJobPostings < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :zipcode, :string
  end

  def self.down
    remove_column :job_postings, :zipcode
  end
end
