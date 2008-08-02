# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080802161026) do

  create_table "countries", :force => true do |t|
    t.string   "isocode"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "pernr"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.date     "planend"
    t.date     "planbeg"
    t.integer  "worktype_id"
    t.integer  "planeffort"
    t.integer  "employee_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teamcommitments", :force => true do |t|
    t.integer  "team_id"
    t.date     "yearmonth"
    t.integer  "project_id"
    t.integer  "days"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teammembers", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "team_id"
    t.date     "endda"
    t.date     "begda"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "worktypes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "preload"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
