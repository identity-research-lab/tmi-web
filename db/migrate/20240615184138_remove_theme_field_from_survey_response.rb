class RemoveThemeFieldFromSurveyResponse < ActiveRecord::Migration[7.1]
  def change
    remove_column :survey_responses, :themes
  end
end
