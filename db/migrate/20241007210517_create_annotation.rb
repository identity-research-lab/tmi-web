class CreateAnnotation < ActiveRecord::Migration[7.2]
  def change
    create_table :annotations do |t|
      t.text :text
      t.timestamps
    end
    add_reference :annotations, :survey_response, null: false, foreign_key: true
  end
end
