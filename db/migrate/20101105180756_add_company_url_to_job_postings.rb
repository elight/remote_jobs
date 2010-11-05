class AddCompanyUrlToJobPostings < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :company_url, :string
  end

  def self.down
    remove_column :job_postings, :company_url
  end
end
