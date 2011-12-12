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

ActiveRecord::Schema.define(:version => 20111212162424) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "face_features", :force => true do |t|
    t.integer  "left_eye_x"
    t.integer  "left_eye_y"
    t.integer  "right_eye_x"
    t.integer  "right_eye_y"
    t.integer  "mouth_x"
    t.integer  "mouth_y"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hat_box_top_left_x"
    t.integer  "hat_box_top_left_y"
    t.integer  "hat_box_top_right_x"
    t.integer  "hat_box_top_right_y"
    t.integer  "hat_box_bottom_left_x"
    t.integer  "hat_box_bottom_left_y"
    t.integer  "hat_box_bottom_right_x"
    t.integer  "hat_box_bottom_right_y"
  end

  create_table "images", :force => true do |t|
    t.string   "filename"
    t.integer  "orientation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "width"
    t.integer  "height"
    t.integer  "hatified_file_size"
    t.string   "hatified_file_checksum"
  end

end
