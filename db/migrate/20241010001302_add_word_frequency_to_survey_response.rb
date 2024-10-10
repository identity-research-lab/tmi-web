class AddWordFrequencyToSurveyResponse < ActiveRecord::Migration[7.2]
  def change
    add_column :survey_responses, :word_frequency, :string, array: true, default: []
  end
end
