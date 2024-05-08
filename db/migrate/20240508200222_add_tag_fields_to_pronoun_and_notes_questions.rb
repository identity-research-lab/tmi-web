class AddTagFieldsToPronounAndNotesQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :survey_responses, :pronouns_id_tags, :string, array: true, default: []
    add_column :survey_responses, :pronouns_exp_tags, :string, array: true, default: []
    add_column :survey_responses, :pronouns_feel_tags, :string, array: true, default: []
    add_column :survey_responses, :affinity_tags, :string, array: true, default: []
    add_column :survey_responses, :notes_tags, :string, array: true, default: []
  end
end
