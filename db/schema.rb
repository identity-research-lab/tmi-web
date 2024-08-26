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

ActiveRecord::Schema[7.1].define(version: 2024_08_20_223410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "survey_responses", force: :cascade do |t|
    t.boolean "finished"
    t.text "age_given"
    t.text "age_exp"
    t.text "klass_given"
    t.text "klass_exp"
    t.text "race_ethnicity_given"
    t.text "race_ethnicity_exp"
    t.text "religion_given"
    t.text "religion_exp"
    t.text "disability_given"
    t.text "disability_exp"
    t.text "neurodiversity_given"
    t.text "neurodiversity_exp"
    t.text "gender_given"
    t.text "gender_exp"
    t.text "lgbtqia_given"
    t.text "lgbtqia_exp"
    t.text "pronouns_given"
    t.text "pronouns_exp"
    t.text "pronouns_feel"
    t.text "affinity"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "age_exp_codes", default: [], array: true
    t.string "klass_exp_codes", default: [], array: true
    t.string "race_ethnicity_exp_codes", default: [], array: true
    t.string "religion_exp_codes", default: [], array: true
    t.string "gender_exp_codes", default: [], array: true
    t.string "disability_exp_codes", default: [], array: true
    t.string "neurodiversity_exp_codes", default: [], array: true
    t.string "lgbtqia_exp_codes", default: [], array: true
    t.string "response_id"
    t.string "age_id_codes", default: [], array: true
    t.string "klass_id_codes", default: [], array: true
    t.string "race_ethnicity_id_codes", default: [], array: true
    t.string "religion_id_codes", default: [], array: true
    t.string "gender_id_codes", default: [], array: true
    t.string "disability_id_codes", default: [], array: true
    t.string "neurodiversity_id_codes", default: [], array: true
    t.string "lgbtqia_id_codes", default: [], array: true
    t.string "pronouns_id_codes", default: [], array: true
    t.string "pronouns_exp_codes", default: [], array: true
    t.string "pronouns_feel_codes", default: [], array: true
    t.string "affinity_codes", default: [], array: true
    t.string "notes_codes", default: [], array: true
    t.string "sentiment"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
