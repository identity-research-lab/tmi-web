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

ActiveRecord::Schema[7.1].define(version: 2024_03_20_220541) do
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
    t.text "age_cope"
    t.text "klass_given"
    t.text "klass_cope"
    t.text "race_given"
    t.text "race_cope"
    t.text "religion_given"
    t.text "religion_cope"
    t.text "disability_given"
    t.text "disability_cope"
    t.text "neurodiversity_given"
    t.text "neurodiversity_cope"
    t.text "gender_given"
    t.text "gender_cope"
    t.text "lgbtq_given"
    t.text "lgbtq_cope"
    t.text "pronouns_given"
    t.text "pronouns_feeling"
    t.text "pronouns_experience"
    t.text "affinity"
    t.text "additional_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tags", default: [], array: true
    t.string "age_identities", default: [], array: true
    t.string "klass_identities", default: [], array: true
    t.string "race_identities", default: [], array: true
    t.string "religion_identities", default: [], array: true
    t.string "gender_identities", default: [], array: true
    t.string "disability_identities", default: [], array: true
    t.string "neurodiversity_identities", default: [], array: true
    t.string "lgbtq_identities", default: [], array: true
    t.string "age_coping_tags", default: [], array: true
    t.string "klass_coping_tags", default: [], array: true
    t.string "race_coping_tags", default: [], array: true
    t.string "religion_coping_tags", default: [], array: true
    t.string "gender_coping_tags", default: [], array: true
    t.string "disability_coping_tags", default: [], array: true
    t.string "neurodiversity_coping_tags", default: [], array: true
    t.string "lgbtq_coping_tags", default: [], array: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
