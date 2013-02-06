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

ActiveRecord::Schema.define(:version => 20130206184041) do

  create_table "awards", :force => true do |t|
    t.string   "name",                   :null => false
    t.string   "social_newtwork",        :null => false
    t.datetime "start_date",             :null => false
    t.datetime "end_date",               :null => false
    t.datetime "expert_voting_end_date", :null => false
    t.text     "comment"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "nominations", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "voting_type",                            :null => false
    t.string   "voting_constraints"
    t.integer  "award_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "nominees_type",      :default => "user", :null => false
  end

  create_table "people", :force => true do |t|
    t.integer  "uid",                         :null => false
    t.string   "first_name",  :default => "", :null => false
    t.string   "last_name",   :default => "", :null => false
    t.string   "screen_name",                 :null => false
    t.integer  "sex",                         :null => false
    t.string   "bdate",       :default => "", :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "uid",                                 :null => false
    t.string   "first_name",          :default => "", :null => false
    t.string   "second_name",         :default => "", :null => false
    t.string   "nickname",            :default => "", :null => false
    t.string   "screen_name",         :default => "", :null => false
    t.integer  "sex",                                 :null => false
    t.string   "bdate",               :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "provider"
    t.string   "token",                               :null => false
    t.boolean  "expires",                             :null => false
    t.date     "expires_at",                          :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer "award_id",      :null => false
    t.integer "nomination_id", :null => false
    t.integer "user_id",       :null => false
    t.integer "nominee_id",    :null => false
    t.string  "nominee_type",  :null => false
    t.date    "created_at",    :null => false
  end

end
