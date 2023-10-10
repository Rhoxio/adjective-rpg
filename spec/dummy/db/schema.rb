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

ActiveRecord::Schema[7.0].define(version: 2023_09_21_083851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bag_items", force: :cascade do |t|
    t.integer "bag_id"
    t.integer "item_id"
    t.integer "position"
    t.integer "stack_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characters", force: :cascade do |t|
    t.integer "hitpoints"
    t.integer "max_hitpoints"
    t.integer "total_experience"
    t.integer "level"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
