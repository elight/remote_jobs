class CreateJobPostings < ActiveRecord::Migration
  def self.up
    create_table :job_postings do |t|
      t.string :title
      t.text :description
      t.boolean :contractor
      t.boolean :hourly
      t.integer :contract_term_length
      t.text :how_to_apply
      t.text :hiring_criteria
      t.integer :category

      t.timestamps
    end
  end

  def self.down
    drop_table :job_postings
  end
end
