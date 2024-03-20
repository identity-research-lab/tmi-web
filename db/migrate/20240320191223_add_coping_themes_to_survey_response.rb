class AddCopingThemesToSurveyResponse < ActiveRecord::Migration[7.1]
  def change
    add_column :survey_responses, :age_coping_themes, :string, array: true, default: []
    add_column :survey_responses, :klass_coping_themes, :string, array: true, default: []
    add_column :survey_responses, :race_coping_themes, :string, array: true, default: []
    add_column :survey_responses, :religion_coping_themes, :string, array: true, default: []
    add_column :survey_responses, :gender_coping_themes, :string, array: true, default: []
    add_column :survey_responses, :disability_coping_themes, :string, array: true, default: []
    add_column :survey_responses, :neurodiversity_coping_themes, :string, array: true, default: []
    add_column :survey_responses, :lgbtq_coping_themes, :string, array: true, default: []
  end
end
