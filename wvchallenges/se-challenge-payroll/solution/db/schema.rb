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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170611033442) do

  create_table "dailyworks", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "workgroup_id"
    t.datetime "date"
    t.float "hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "report_id"
    t.index ["employee_id"], name: "index_dailyworks_on_employee_id"
    t.index ["report_id"], name: "index_dailyworks_on_report_id"
    t.index ["workgroup_id"], name: "index_dailyworks_on_workgroup_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "gender"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timesheet_statuses", force: :cascade do |t|
    t.integer "report_id"
    t.datetime "process_time"
    t.integer "status"
    t.integer "error"
    t.text "employees"
    t.text "workgroups"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filename", null: false
    t.index ["report_id"], name: "index_timesheet_statuses_on_report_id"
  end

  create_table "workgroups", force: :cascade do |t|
    t.string "category"
    t.string "name"
    t.decimal "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
