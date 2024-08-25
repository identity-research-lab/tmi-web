# SurveyResponse objects are upserted when a survey data CSV file is imported.
class ImportFromCsv

	attr_accessor :record, :survey_response

	REQUIRED_FIELDS = [:age_given]
			
	# Given a file handle to a data file, parse the file contents as CSV and hydrate SurveyResponse records in serial.
	def self.perform(file_handle)
		CSV.read(file_handle, headers: true).each do |record|
			new(record).import
		end
	end
	
	def initialize(record)
		@record = record
		@survey_response ||= SurveyResponse.find_or_initialize_by(response_id: record['ResponseId'])
	end

	# Hydrates a SurveyResponse object from a record in the imported CSV data file.
	def import
		return unless record_valid?
		
		survey_response.update(
			age_given: record['age_given'],
			age_exp: record['age_exp'],
			klass_given: record['klass_given'],
			klass_exp: record['klass_exp'],
			race_ethnicity_given: record['race_ethnicity_given'],
			race_ethnicity_exp: record['race_ethnicity_exp'],
			religion_given: record['religion_given'],
			religion_exp: record['religion_exp'],
			disability_given: record['disability_given'],
			disability_exp: record['disability_exp'],
			neurodiversity_given: record['neurodiversity_given'],
			neurodiversity_exp: record['neurodiversity_exp'],
			gender_given: record['gender_given'],
			gender_exp: record['gender_exp'],
			lgbtqia_given: record['lgbtqia_given'],
			lgbtqia_exp: record['lgbtqia_exp'],
			pronouns_given: pronouns,
			pronouns_exp: record['pronouns_exp'],
			pronouns_feel: record['pronouns_feel'],
			affinity: record['affinity'],
			notes: record['notes']
		)
	end

	private
		
	def pronouns
		return "#{record['pronouns_given_5_TEXT']} (self-described)" if record['pronouns_given'] == "self-describe"
		return record['pronouns_given']
	end
	
	def record_valid?
		REQUIRED_FIELDS.select{ |field| record[field.to_s].present? }.count == REQUIRED_FIELDS.count
	end
	
end