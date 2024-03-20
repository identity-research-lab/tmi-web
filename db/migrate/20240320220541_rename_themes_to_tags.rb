class RenameThemesToTags < ActiveRecord::Migration[7.1]
  def change
    rename_column :survey_responses, :themes, :tags
    rename_column :survey_responses, :age_coping_themes, :age_coping_tags
    rename_column :survey_responses, :klass_coping_themes, :klass_coping_tags
    rename_column :survey_responses, :race_coping_themes, :race_coping_tags
    rename_column :survey_responses, :religion_coping_themes, :religion_coping_tags
    rename_column :survey_responses, :gender_coping_themes, :gender_coping_tags
    rename_column :survey_responses, :disability_coping_themes, :disability_coping_tags
    rename_column :survey_responses, :neurodiversity_coping_themes, :neurodiversity_coping_tags
    rename_column :survey_responses, :lgbtq_coping_themes, :lgbtq_coping_tags
  end
end
