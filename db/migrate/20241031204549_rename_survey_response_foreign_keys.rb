class RenameSurveyResponseForeignKeys < ActiveRecord::Migration[7.2]
  def change
    rename_column :annotations, :survey_response_id, :case_id
    rename_column :responses, :survey_response_id, :case_id
  end
end
