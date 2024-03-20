class AddIdentitiesToSurveyResponse < ActiveRecord::Migration[7.1]
 def change
   add_column :survey_responses, :age_identities, :string, array: true, default: []
   add_column :survey_responses, :klass_identities, :string, array: true, default: []
   add_column :survey_responses, :race_identities, :string, array: true, default: []
   add_column :survey_responses, :religion_identities, :string, array: true, default: []
   add_column :survey_responses, :gender_identities, :string, array: true, default: []
   add_column :survey_responses, :disability_identities, :string, array: true, default: []
   add_column :survey_responses, :neurodiversity_identities, :string, array: true, default: []
   add_column :survey_responses, :lgbtq_identities, :string, array: true, default: []
 end
end
