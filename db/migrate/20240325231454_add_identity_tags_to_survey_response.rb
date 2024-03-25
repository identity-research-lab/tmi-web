class AddIdentityTagsToSurveyResponse < ActiveRecord::Migration[7.1]
  def change
    add_column :survey_responses, :age_id_tags, :string, array: true, default: []
    add_column :survey_responses, :klass_id_tags, :string, array: true, default: []
    add_column :survey_responses, :race_ethnicity_id_tags, :string, array: true, default: []
    add_column :survey_responses, :religion_id_tags, :string, array: true, default: []
    add_column :survey_responses, :gender_id_tags, :string, array: true, default: []
    add_column :survey_responses, :disability_id_tags, :string, array: true, default: []
    add_column :survey_responses, :neurodiversity_id_tags, :string, array: true, default: []
    add_column :survey_responses, :lgbtqia_id_tags, :string, array: true, default: []
  end
end
