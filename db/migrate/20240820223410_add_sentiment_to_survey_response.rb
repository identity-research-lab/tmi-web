class AddSentimentToSurveyResponse < ActiveRecord::Migration[7.1]
  def change
    add_column :survey_responses, :sentiment, :string
  end
end
