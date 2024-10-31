class RenameSurveyResponsesToCases < ActiveRecord::Migration[7.2]
  def change
    rename_table :survey_responses, :cases
  end
end
