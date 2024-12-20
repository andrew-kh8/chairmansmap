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

ActiveRecord::Schema[7.0].define(version: 2024_07_27_135931) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "hunter_locations", force: :cascade do |t|
    t.geometry "location", limit: {:srid=>28406, :type=>"st_point"}, null: false
    t.datetime "date", null: false
    t.text "description"
    t.boolean "license"
    t.boolean "dog"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.bigserial "plot_id", null: false
    t.bigint "person_id", null: false
    t.date "active_from"
    t.date "active_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_owners_on_person_id"
    t.index ["plot_id"], name: "index_owners_on_plot_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "surname"
    t.string "tel"
    t.string "address"
    t.date "birth"
    t.date "member_from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_people_on_discarded_at"
  end

  create_table "plot_data", force: :cascade do |t|
    t.bigserial "plot_id", null: false
    t.string "description"
    t.string "sale_status"
    t.string "owner_type"
    t.string "kadastr_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plot_id"], name: "index_plot_data_on_plot_id"
  end

  create_table "plots", id: false, force: :cascade do |t|
    t.serial "gid", null: false
    t.float "area", null: false
    t.float "perimetr", null: false
    t.integer "number", null: false
    t.geometry "geom", limit: {:srid=>4326, :type=>"multi_polygon"}
    t.index ["number"], name: "index_plots_on_number", unique: true
  end

  add_foreign_key "owners", "people"
end
