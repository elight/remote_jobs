class AddEnabledToJobPosting < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :enabled, :boolean, :default => true
  end

  def self.down
    remove_column :job_postings, :enabled
  end
end
