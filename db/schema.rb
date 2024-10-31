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

ActiveRecord::Schema[7.2].define(version: 2024_10_31_204549) do
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

  create_table "annotations", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "case_id", null: false
    t.index ["case_id"], name: "index_annotations_on_case_id"
  end

  create_table "cases", force: :cascade do |t|
    t.boolean "finished"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "response_id"
    t.string "sentiment"
    t.string "word_frequency", default: [], array: true
  end

  create_table "contexts", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "suggested_categories", default: [], array: true
    t.datetime "suggestions_updated_at"
  end

  create_table "questions", force: :cascade do |t|
    t.string "key"
    t.string "label"
    t.boolean "is_experience", default: false
    t.boolean "is_identity", default: false
    t.boolean "is_feeling", default: false
    t.boolean "is_affinity", default: false
    t.boolean "is_reflection", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "context_id"
    t.index ["context_id"], name: "index_questions_on_context_id"
  end

  create_table "responses", force: :cascade do |t|
    t.text "value"
    t.string "raw_codes", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "question_id", null: false
    t.bigint "case_id", null: false
    t.index ["case_id"], name: "index_responses_on_case_id"
    t.index ["question_id"], name: "index_responses_on_question_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "annotations", "cases"
  add_foreign_key "questions", "contexts"
  add_foreign_key "responses", "cases"
  add_foreign_key "responses", "questions"
end
