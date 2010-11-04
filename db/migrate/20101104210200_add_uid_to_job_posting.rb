class AddUidToJobPosting < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :uid, :string
    add_index :job_postings, :uid
  end

  def self.down
    remove_index :job_postings, :uid
    add_column :job_postings, :uid, :string
  end
end
