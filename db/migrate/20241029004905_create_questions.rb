class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.string :key
      t.string :label
      t.boolean :is_experience, default: false
      t.boolean :is_identity, default: false
      t.boolean :is_feeling, default: false
      t.boolean :is_affinity, default: false
      t.boolean :is_reflection, default: false
      t.timestamps
    end
    add_reference :questions, :context, null: true, foreign_key: true
  end
end
