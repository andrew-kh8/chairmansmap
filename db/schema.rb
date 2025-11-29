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

ActiveRecord::Schema[8.1].define(version: 2025_11_23_085416) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"
  enable_extension "postgis"

  create_table "public.data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "public.hunter_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date", null: false
    t.text "description"
    t.boolean "dog"
    t.boolean "license"
    t.geometry "location", limit: {:srid=>3857, :type=>"st_point"}, null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.owners", force: :cascade do |t|
    t.date "active_from"
    t.date "active_to"
    t.datetime "created_at", null: false
    t.bigint "person_id", null: false
    t.uuid "plot_id"
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_owners_on_person_id"
  end

  create_table "public.people", force: :cascade do |t|
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

  create_table "public.plot_data", force: :cascade do |t|
    t.string "cadastral_number"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "owner_type"
    t.uuid "plot_id"
    t.string "sale_status"
    t.datetime "updated_at", null: false
    t.index ["cadastral_number"], name: "index_plot_data_on_cadastral_number", unique: true
  end

  create_table "public.plots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "area", null: false
    t.datetime "created_at", null: false
    t.geometry "geom", limit: {:srid=>3857, :type=>"multi_polygon"}, null: false
    t.serial "gid", null: false
    t.integer "number", null: false
    t.float "perimeter", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_plots_on_number", unique: true
  end

  add_foreign_key "public.owners", "public.people"
  add_foreign_key "public.owners", "public.plots"
  add_foreign_key "public.plot_data", "public.plots"
end
