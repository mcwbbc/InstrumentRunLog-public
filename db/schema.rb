# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20140924185407) do

  create_table "blanks", :force => true do |t|
    t.string   "name"
    t.integer  "runs"
    t.integer  "gradient"
    t.integer  "entry_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.date     "date_run"
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "instrument"
    t.integer  "blank_runs"
    t.integer  "blank_gradient"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pi"
    t.string   "department"
    t.integer  "invoice_id"
    t.integer  "lab_id"
    t.string   "purchase_order"
    t.text     "comments"
    t.integer  "updated_by_id"
    t.boolean  "unbillable"
  end

  create_table "instruments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labs_projects", :id => false, :force => true do |t|
    t.integer "lab_id"
    t.integer "project_id"
  end

  create_table "maintenance_entries", :force => true do |t|
    t.integer  "minutes"
    t.text     "notes"
    t.integer  "user_id"
    t.integer  "instrument_id"
    t.datetime "date_conducted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_models", :force => true do |t|
    t.integer  "instrument_id"
    t.integer  "category_id"
    t.float    "digest_price"
    t.float    "hour_price"
    t.float    "sample_price"
    t.date     "effective_date"
    t.date     "retire_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.boolean  "additional_required", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", :force => true do |t|
    t.integer  "digests"
    t.integer  "runs"
    t.integer  "gradient"
    t.float    "sample_price"
    t.float    "digest_price"
    t.float    "hour_price"
    t.string   "category"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
    t.integer  "loading_time"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.integer  "role"
    t.integer  "lab_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
