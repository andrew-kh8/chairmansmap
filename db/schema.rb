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

ActiveRecord::Schema[8.1].define(version: 2026_02_28_142459) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"
  enable_extension "postgis"

  create_table "agromonitoring_tiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "cloud_coverage", null: false
    t.datetime "created_at", null: false
    t.datetime "date", null: false
    t.string "dswi_url", null: false
    t.string "evi2_url", null: false
    t.string "evi_url", null: false
    t.string "falsecolor_url", null: false
    t.string "ndvi_url", null: false
    t.string "ndwi_url", null: false
    t.string "nri_url", null: false
    t.string "satellite", null: false
    t.string "truecolor_url", null: false
    t.datetime "updated_at", null: false
    t.integer "valid_data_coverage", null: false
    t.uuid "village_id", null: false
    t.index ["village_id"], name: "index_agromonitoring_tiles_on_village_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "hunter_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date", null: false
    t.text "description"
    t.boolean "dog"
    t.boolean "license"
    t.geometry "location", limit: {:srid=>3857, :type=>"st_point"}, null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.date "active_from"
    t.date "active_to"
    t.datetime "created_at", null: false
    t.bigint "person_id", null: false
    t.uuid "plot_id"
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_owners_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "address"
    t.date "birth"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "first_name"
    t.date "member_from"
    t.string "middle_name"
    t.string "surname"
    t.string "tel"
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_people_on_discarded_at"
  end

  create_table "plots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "area", null: false
    t.string "cadastral_number"
    t.datetime "created_at", null: false
    t.string "description"
    t.geometry "geom", limit: {:srid=>3857, :type=>"multi_polygon"}, null: false
    t.integer "number", null: false
    t.string "owner_type"
    t.float "perimeter", null: false
    t.string "sale_status"
    t.datetime "updated_at", null: false
    t.index ["cadastral_number"], name: "index_plots_on_cadastral_number", unique: true
    t.index ["number"], name: "index_plots_on_number", unique: true
  end

  create_table "villages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "agromonitoring_id"
    t.string "cadastral_number"
    t.datetime "created_at", null: false
    t.geometry "geom", limit: {:srid=>3857, :type=>"multi_polygon"}
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["agromonitoring_id"], name: "index_villages_on_agromonitoring_id", unique: true
    t.index ["cadastral_number"], name: "index_villages_on_cadastral_number", unique: true
  end

  add_foreign_key "agromonitoring_tiles", "villages"
  add_foreign_key "owners", "people"
  add_foreign_key "owners", "plots"
end
