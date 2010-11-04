class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :street_address1
      t.string :street_address2
      t.string :city
      t.string :state
      t.string :country
      t.string :phone_number

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
