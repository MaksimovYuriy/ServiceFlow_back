# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_01_07_071150) do
  create_table "clients", force: :cascade do |t|
    t.string "full_name"
    t.string "phone"
    t.string "telegram"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "masters", force: :cascade do |t|
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "salary"
    t.boolean "active"
  end

  create_table "materials", force: :cascade do |t|
    t.string "title"
    t.integer "quantity"
    t.integer "minimal_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.datetime "date"
    t.integer "status"
    t.float "total_price"
    t.integer "service_id", null: false
    t.integer "client_id", null: false
    t.integer "master_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_notes_on_client_id"
    t.index ["master_id"], name: "index_notes_on_master_id"
    t.index ["service_id"], name: "index_notes_on_service_id"
  end

  create_table "service_masters", force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "master_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_id"], name: "index_service_masters_on_master_id"
    t.index ["service_id"], name: "index_service_masters_on_service_id"
  end

  create_table "service_materials", force: :cascade do |t|
    t.float "required_quantity"
    t.integer "service_id", null: false
    t.integer "material_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_service_materials_on_material_id"
    t.index ["service_id"], name: "index_service_materials_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "duration"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "phone"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "notes", "clients"
  add_foreign_key "notes", "masters"
  add_foreign_key "notes", "services"
  add_foreign_key "service_masters", "masters"
  add_foreign_key "service_masters", "services"
  add_foreign_key "service_materials", "materials"
  add_foreign_key "service_materials", "services"
end
