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

ActiveRecord::Schema.define(:version => 20100314191808) do

  create_table "audit_trails", :force => true do |t|
    t.integer  "record_id"
    t.string   "record_type"
    t.string   "event"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "isocode"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  create_table "cpro_projects", :force => true do |t|
    t.integer  "project_id"
    t.string   "cpro_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "pernr"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_reviewer"
  end

  create_table "projectareas", :force => true do |t|
    t.string   "area"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.date     "planend"
    t.date     "planbeg"
    t.integer  "worktype_id"
    t.decimal  "planeffort"
    t.integer  "employee_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",         :limit => 1
    t.string   "srs_url"
    t.string   "sdd_url"
    t.integer  "projectarea_id"
  end

  create_table "projecttracks", :force => true do |t|
    t.integer  "team_id"
    t.date     "yearmonth"
    t.integer  "project_id"
    t.date     "reportdate"
    t.decimal  "daysbooked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviewers", :force => true do |t|
    t.integer "project_id"
    t.integer "employee_id"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "project_id"
    t.text     "notes"
    t.integer  "user_id"
    t.integer  "rtype"
    t.integer  "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights", :force => true do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer  "right_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tasks", :force => true do |t|
    t.integer "teamcommitment_id"
    t.integer "employee_id"
  end

  create_table "teamcommitments", :force => true do |t|
    t.integer  "team_id"
    t.date     "yearmonth"
    t.integer  "project_id"
    t.decimal  "days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",     :limit => 1
  end

  create_table "teammembers", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "team_id"
    t.date     "endda"
    t.date     "begda"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "percentage"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  create_table "worktypes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "preload"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "needs_review"
    t.boolean  "is_continuous"
  end

end
