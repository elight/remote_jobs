class CreateJobPostings < ActiveRecord::Migration
  def self.up
    create_table :job_postings do |t|
      t.string :title
      t.text :description
      t.string :job_type
      t.string :payment_type
      t.integer :contract_term_length
      t.text :how_to_apply
      t.text :hiring_criteria
      t.string :category

      t.string :company_name

      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :street_address1
      t.string :street_address2
      t.string :city
      t.string :state
      t.string :country
      t.string :phone_number

      t.string :uid

      t.timestamps
    end
    add_index :job_postings, :uid
  end

  def self.down
    remove_index :job_postings, :uid
    drop_table :job_postings
  end
end
