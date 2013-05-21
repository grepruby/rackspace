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

ActiveRecord::Schema.define(:version => 20120906085025) do

  create_table "analytics", :force => true do |t|
    t.integer  "tracker_id"
    t.integer  "app_token_id"
    t.string   "tracker_type", :limit => 45
    t.integer  "event_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_tokens", :force => true do |t|
    t.string   "udid",                           :limit => 128
    t.string   "notifications",                  :limit => 128
    t.boolean  "new_specials_notifications"
    t.boolean  "updated_specials_notifications"
    t.boolean  "expire_specials_notifications"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_tokens_restaurants", :id => false, :force => true do |t|
    t.integer "app_token_id"
    t.integer "restaurant_id"
  end

  add_index "app_tokens_restaurants", ["app_token_id", "restaurant_id"], :name => "by_app_token_restaurants", :unique => true

  create_table "app_tokens_specials", :id => false, :force => true do |t|
    t.integer "app_token_id"
    t.integer "special_id"
  end

  add_index "app_tokens_specials", ["app_token_id", "special_id"], :name => "by_app_token_specials", :unique => true

  create_table "billing_informations", :force => true do |t|
    t.integer  "user_id"
    t.string   "full_name"
    t.string   "billing_address_1"
    t.string   "billing_address_2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "food_categories", :force => true do |t|
    t.string "name", :limit => 50
  end

  create_table "food_categories_restaurants", :id => false, :force => true do |t|
    t.integer "food_category_id"
    t.integer "restaurant_id"
  end

  add_index "food_categories_restaurants", ["food_category_id", "restaurant_id"], :name => "by_food_categories_restaurants", :unique => true

  create_table "restaurants", :force => true do |t|
    t.string   "name",               :limit => 100
    t.string   "website",            :limit => 200
    t.string   "phone_number",       :limit => 18
    t.string   "address"
    t.string   "city",               :limit => 50
    t.decimal  "cost",                              :precision => 6, :scale => 2
    t.string   "zipcode",            :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state_id"
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "menu_url"
    t.string   "video_url"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specials", :force => true do |t|
    t.string   "title",              :limit => 100
    t.text     "deal_details"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
    t.string   "tags"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "states", :force => true do |t|
    t.string "alpha_code", :limit => 5
    t.string "name",       :limit => 30
  end

  add_index "states", ["alpha_code"], :name => "index_states_on_alpha_code"

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.decimal  "cost",       :precision => 6, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_paperclip_files", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "zip"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
    t.string   "arb_subscription_id"
    t.integer  "billing_information_id"
    t.string   "arb_status"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
