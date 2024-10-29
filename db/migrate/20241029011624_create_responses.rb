class CreateResponses < ActiveRecord::Migration[7.2]
  def change
    create_table :responses do |t|
      t.text :value
      t.string :raw_codes, array: true, default: []
      t.timestamps
    end
    add_reference :responses, :question, null: false, foreign_key: true
    add_reference :responses, :survey_response, null: false, foreign_key: true
  end
end
