class AddThemesToSurveyResponse < ActiveRecord::Migration[7.1]
  def change
    add_column :survey_responses, :themes, :string, array: true, default: []
  end
end
