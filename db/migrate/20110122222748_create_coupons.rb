class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :code
      t.integer :job_posting_id

      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
