namespace :export do

	desc 'Export SurveyResponse records to a CSV file'
	task survey_responses: :environment do
		require 'csv'

		# Define the file path for the CSV
		file_path = Rails.root.join('export', 'survey_responses.csv')

		# Create the directory if it doesn't exist
		FileUtils.mkdir_p(File.dirname(file_path))

		questions = Question.all

		# Open the CSV file and write the data
		CSV.open(file_path, 'w') do |csv|
			# Write the header row
			columns = ["source_record_id"] + questions.map(&:key)
			csv << columns

			# Fetch the SurveyResponse records and write each one to the CSV
			SurveyResponse.find_each do |survey_response|
				csv << [survey_response.id] + Response.where(survey_response_id: survey_response.id).order(:question_id).map(&:value)
			end
		end

		puts "Survey responses have been successfully exported to #{file_path}"
	end

	task sample_data: :environment do
		require 'csv'

		# Define the file path for the CSV
		file_path = Rails.root.join('export', 'sample_data.csv')

		# Create the directory if it doesn't exist
		FileUtils.mkdir_p(File.dirname(file_path))

		# Open the CSV file and write the data
		CSV.open(file_path, 'w') do |csv|
			# Write the header row
			columns = ["source_record_id"] + Question.all.map(&:key)
			csv << columns

			# Fetch the SurveyResponse records and write each one to the CSV
			100.times do |i|
				csv << [i] + Question.all.map{ |q| Faker::Lorem.sentence }
			end
		end

		puts "A sample CSV been successfully exported to #{file_path}"
	end

end
