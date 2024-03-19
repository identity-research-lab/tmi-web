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

ActiveRecord::Schema[7.1].define(version: 2024_03_18_234248) do
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
  end

end
