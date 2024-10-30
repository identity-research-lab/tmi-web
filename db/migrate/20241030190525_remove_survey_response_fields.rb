class RemoveSurveyResponseFields < ActiveRecord::Migration[7.2]
  def up
    remove_column :survey_responses, :age_given
    remove_column :survey_responses, :age_exp
    remove_column :survey_responses, :klass_given
    remove_column :survey_responses, :klass_exp
    remove_column :survey_responses, :race_ethnicity_given
    remove_column :survey_responses, :race_ethnicity_exp
    remove_column :survey_responses, :religion_given
    remove_column :survey_responses, :religion_exp
    remove_column :survey_responses, :disability_given
    remove_column :survey_responses, :disability_exp
    remove_column :survey_responses, :neurodiversity_given
    remove_column :survey_responses, :neurodiversity_exp
    remove_column :survey_responses, :gender_given
    remove_column :survey_responses, :gender_exp
    remove_column :survey_responses, :lgbtqia_given
    remove_column :survey_responses, :lgbtqia_exp
    remove_column :survey_responses, :pronouns_given
    remove_column :survey_responses, :pronouns_exp
    remove_column :survey_responses, :pronouns_feel
    remove_column :survey_responses, :affinity
    remove_column :survey_responses, :notes
    remove_column :survey_responses, :age_exp_codes
    remove_column :survey_responses, :klass_exp_codes
    remove_column :survey_responses, :race_ethnicity_exp_codes
    remove_column :survey_responses, :religion_exp_codes
    remove_column :survey_responses, :gender_exp_codes
    remove_column :survey_responses, :disability_exp_codes
    remove_column :survey_responses, :neurodiversity_exp_codes
    remove_column :survey_responses, :lgbtqia_exp_codes
    remove_column :survey_responses, :age_id_codes
    remove_column :survey_responses, :klass_id_codes
    remove_column :survey_responses, :race_ethnicity_id_codes
    remove_column :survey_responses, :religion_id_codes
    remove_column :survey_responses, :gender_id_codes
    remove_column :survey_responses, :disability_id_codes
    remove_column :survey_responses, :neurodiversity_id_codes
    remove_column :survey_responses, :lgbtqia_id_codes
    remove_column :survey_responses, :pronouns_id_codes
    remove_column :survey_responses, :pronouns_exp_codes
    remove_column :survey_responses, :pronouns_feel_codes
    remove_column :survey_responses, :affinity_codes
    remove_column :survey_responses, :notes_codes
  end

  def down
    add_column :survey_responses, :age_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :klass_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :race_ethnicity_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :religion_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :gender_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :disability_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :neurodiversity_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :lgbtqia_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :age_id_codes, :string, array: true, default: []
    add_column :survey_responses, :klass_id_codes, :string, array: true, default: []
    add_column :survey_responses, :race_ethnicity_id_codes, :string, array: true, default: []
    add_column :survey_responses, :religion_id_codes, :string, array: true, default: []
    add_column :survey_responses, :gender_id_codes, :string, array: true, default: []
    add_column :survey_responses, :disability_id_codes, :string, array: true, default: []
    add_column :survey_responses, :neurodiversity_id_codes, :string, array: true, default: []
    add_column :survey_responses, :lgbtqia_id_codes, :string, array: true, default: []
    add_column :survey_responses, :pronouns_id_codes, :string, array: true, default: []
    add_column :survey_responses, :pronouns_exp_codes, :string, array: true, default: []
    add_column :survey_responses, :pronouns_feel_codes, :string, array: true, default: []
    add_column :survey_responses, :affinity_codes, :string, array: true, default: []
    add_column :survey_responses, :notes_codes, :string, array: true, default: []
    add_column :survey_responses, :age_given, :text
    add_column :survey_responses, :age_exp, :text
    add_column :survey_responses, :klass_given, :text
    add_column :survey_responses, :klass_exp, :text
    add_column :survey_responses, :race_ethnicity_given, :text
    add_column :survey_responses, :race_ethnicity_exp, :text
    add_column :survey_responses, :religion_given, :text
    add_column :survey_responses, :religion_exp, :text
    add_column :survey_responses, :disability_given, :text
    add_column :survey_responses, :disability_exp, :text
    add_column :survey_responses, :neurodiversity_given, :text
    add_column :survey_responses, :neurodiversity_exp, :text
    add_column :survey_responses, :gender_given, :text
    add_column :survey_responses, :gender_exp, :text
    add_column :survey_responses, :lgbtqia_given, :text
    add_column :survey_responses, :lgbtqia_exp, :text
    add_column :survey_responses, :pronouns_given, :text
    add_column :survey_responses, :pronouns_exp, :text
    add_column :survey_responses, :pronouns_feel, :text
    add_column :survey_responses, :affinity, :text
    add_column :survey_responses, :notes, :text
  end

end
