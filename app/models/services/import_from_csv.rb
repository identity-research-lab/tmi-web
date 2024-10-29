module Services

	require 'csv'

	# Upserts SurveyResponse objects CSV file is imported. This operation is non-destructive.
	class ImportFromCsv

		attr_accessor :record

		# Given a file handle to a data file, parse the file contents as CSV and hydrate SurveyResponse records in serial.
		def self.perform(file_handle)
			CSV.read(file_handle, headers: true).each do |record|
				new(record).perform
			end
		end

		def initialize(record)
			@record = record
		end

		# Hydrates a sufficiently complete SurveyResponse object and associated Response objects from a row in the imported CSV data file.
		def perform
			return unless record_valid?
			survey_response = SurveyResponse.find_or_create_by(response_id: record['ResponseId'] || record['source_record_id'])
			row_hash = Question.all.map(&:key).inject({}) { |accumulator, key| accumulator[key] = record[key]; accumulator }
		  PopulateSurveyResponseJob.perform_async(survey_response.id, row_hash)
		end

		private

		# Pronoun data can come from a radio button or a freeform text field. We want to distinguish between the two by
		# flagging freeform answers as "self-described".
		def pronouns
			return "#{record['pronouns_given_5_TEXT'] || record['pronouns_given_text']} (self-described)" if record['pronouns_given'] == "self-describe"
			return record['pronouns_given']
		end

		# If a SurveyResponse doesn't contain a response for the required fields, it will be considered invalid.
		def record_valid?
			Question.identity_questions.map(&:key).select{ |key| record[key.to_s].present? }.count >= 1
		end

	end
end
