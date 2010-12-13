class ChangeContractTermLengthToString < ActiveRecord::Migration
  def self.up
    remove_column :job_postings, :contract_term_length
    add_column :job_postings, :contract_term_length, :string
  end

  def self.down
    remove_column :job_postings, :contract_term_length
    add_column :job_postings, :contract_term_length, :integer
  end
end
