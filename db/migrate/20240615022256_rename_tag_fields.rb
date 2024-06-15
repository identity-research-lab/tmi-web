class RenameTagFields < ActiveRecord::Migration[7.1]
  def change
    rename_column :survey_responses, :age_exp_tags, :age_exp_codes
    rename_column :survey_responses, :klass_exp_tags, :klass_exp_codes
    rename_column :survey_responses, :race_ethnicity_exp_tags, :race_ethnicity_exp_codes
    rename_column :survey_responses, :religion_exp_tags, :religion_exp_codes
    rename_column :survey_responses, :gender_exp_tags, :gender_exp_codes
    rename_column :survey_responses, :disability_exp_tags, :disability_exp_codes
    rename_column :survey_responses, :neurodiversity_exp_tags, :neurodiversity_exp_codes
    rename_column :survey_responses, :lgbtqia_exp_tags, :lgbtqia_exp_codes
    rename_column :survey_responses, :age_id_tags, :age_id_codes
    rename_column :survey_responses, :klass_id_tags, :klass_id_codes
    rename_column :survey_responses, :race_ethnicity_id_tags, :race_ethnicity_id_codes
    rename_column :survey_responses, :religion_id_tags, :religion_id_codes
    rename_column :survey_responses, :gender_id_tags, :gender_id_codes
    rename_column :survey_responses, :disability_id_tags, :disability_id_codes
    rename_column :survey_responses, :neurodiversity_id_tags, :neurodiversity_id_codes
    rename_column :survey_responses, :lgbtqia_id_tags, :lgbtqia_id_codes
    rename_column :survey_responses, :pronouns_id_tags, :pronouns_id_codes
    rename_column :survey_responses, :pronouns_exp_tags, :pronouns_exp_codes
    rename_column :survey_responses, :pronouns_feel_tags, :pronouns_feel_codes
    rename_column :survey_responses, :affinity_tags, :affinity_codes
    rename_column :survey_responses, :notes_tags, :notes_codes
  end
end
