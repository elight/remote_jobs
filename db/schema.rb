# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110220194728) do

  create_table "coupons", :force => true do |t|
    t.string   "code"
    t.integer  "job_posting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", :force => true do |t|
    t.string   "number"
    t.integer  "month"
    t.integer  "year"
    t.integer  "cvv"
    t.integer  "job_posting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_postings", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "job_type"
    t.string   "payment_type"
    t.text     "how_to_apply"
    t.text     "hiring_criteria"
    t.string   "category"
    t.string   "company_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "street_address1"
    t.string   "street_address2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "phone_number"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_url"
    t.boolean  "enabled",              :default => false
    t.string   "contract_term_length"
    t.string   "zipcode"
  end

  add_index "job_postings", ["uid"], :name => "index_job_postings_on_uid"

end
