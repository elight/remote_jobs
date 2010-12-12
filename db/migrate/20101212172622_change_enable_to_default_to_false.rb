class ChangeEnableToDefaultToFalse < ActiveRecord::Migration
  def self.up
    remove_column :job_postings, :enabled
    add_column :job_postings, :enabled, :boolean, :default => false
  end

  def self.down
    remove_column :job_postings, :enabled
    add_column :job_postings, :enabled, :boolean, :default => true
  end
end
