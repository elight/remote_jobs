class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.string :number
      t.integer :month
      t.integer :year
      t.integer :cvv
      t.integer :job_posting_id

      t.timestamps
    end
  end

  def self.down
    drop_table :credit_cards
  end
end
