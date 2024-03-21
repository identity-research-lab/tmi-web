class AddExperienceThemesToSurveyResponse < ActiveRecord::Migration[7.1]
  def change
    add_column :survey_responses, :age_exp_tags, :string, array: true, default: []
    add_column :survey_responses, :klass_exp_tags, :string, array: true, default: []
    add_column :survey_responses, :race_ethnicity_exp_tags, :string, array: true, default: []
    add_column :survey_responses, :religion_exp_tags, :string, array: true, default: []
    add_column :survey_responses, :gender_exp_tags, :string, array: true, default: []
    add_column :survey_responses, :disability_exp_tags, :string, array: true, default: []
    add_column :survey_responses, :neurodiversity_exp_tags, :string, array: true, default: []
    add_column :survey_responses, :lgbtqia_exp_tags, :string, array: true, default: []
  end
end
