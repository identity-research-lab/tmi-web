class AddResponseIdToSurveyResponse < ActiveRecord::Migration[7.1]
  def change
    add_column :survey_responses, :response_id, :string
  end
end
