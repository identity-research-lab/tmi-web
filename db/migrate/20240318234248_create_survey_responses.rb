class CreateSurveyResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :survey_responses do |t|
      t.boolean :finished
      t.text :age_given
      t.text :age_cope
      t.text :klass_given
      t.text :klass_cope
      t.text :race_given
      t.text :race_cope
      t.text :religion_given
      t.text :religion_cope
      t.text :disability_given
      t.text :disability_cope
      t.text :neurodiversity_given
      t.text :neurodiversity_cope
      t.text :gender_given
      t.text :gender_cope
      t.text :lgbtq_given
      t.text :lgbtq_cope
      t.text :pronouns_given
      t.text :pronouns_feeling
      t.text :pronouns_experience
      t.text :affinity
      t.text :additional_notes
      t.timestamps
    end
  end
end
