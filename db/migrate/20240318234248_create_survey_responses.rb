class CreateSurveyResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :survey_responses do |t|
      t.boolean :finished
      t.text :age_given
      t.text :age_exp
      t.text :klass_given
      t.text :klass_exp
      t.text :race_ethnicity_given
      t.text :race_ethnicity_exp
      t.text :religion_given
      t.text :religion_exp
      t.text :disability_given
      t.text :disability_exp
      t.text :neurodiversity_given
      t.text :neurodiversity_exp
      t.text :gender_given
      t.text :gender_exp
      t.text :lgbtqia_given
      t.text :lgbtqia_exp
      t.text :pronouns_given
      t.text :pronouns_exp
      t.text :pronouns_feel
      t.text :affinity
      t.text :notes
      t.timestamps
    end
  end
end
