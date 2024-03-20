class SurveyResponse < ApplicationRecord

	require 'csv'
	require 'openai'

	before_validation :sanitize_array_values
	after_create :detect_themes, :detect_identities
	
	THEME_PROMPT = "What themes are present in the following text? Be specific. Please answer with a simple comma-separated list."
	
	IDENTITY_PROMPT = "Provide a single comma-separated list of all noun and adjectival phrases from the following text. Do not substitute any words. The text is as follows: "
	
	IDENTITY_ATTRIBUTES = [:age_given, :klass_given, :race_given, :religion_given, :disability_given, :neurodiversity_given, :gender_given, :lgbtq_given]
	
	QUESTION_MAPPING = {
		age_given: "Age",
		age_cope: "Experience with Age",
		klass_given: "Class",
		klass_cope: "Experience with Class",
		race_given: "Race/Ethnicity",
		race_cope: "Experience with Race/Ethnicity",
		religion_given: "Religion",
		religion_cope: "Experience with Religion",
		disability_given: "Disability",
		disability_cope: "Experience with Disability",
		neurodiversity_given: "Neurodiversity",
		neurodiversity_cope: "Experience with Neurodiversity",
		gender_given: "Gender",
		gender_cope: "Experience with Gender",
		lgbtq_given: "LGBTQIA+ Status",
		lgbtq_cope: "Experience with LGBTQIA+",
		pronouns_given: "Pronouns Given",
		pronouns_feeling: "Pronoun Feelings",
		pronouns_experience: "Experience with Pronouns",
		affinity: "Identity Affinities",
		additional_notes: "Identity Notes"
	}

	def self.refresh_from_csv
		SurveyResponse.destroy_all
		CSV.read("./data/survey.csv", headers: true).each do |record|
			next unless record['Progress'].to_i.to_s == record['Progress']
			create_from_record(record)
		end
	end

	def self.refresh_from_upload(file_handle)
		SurveyResponse.destroy_all
		CSV.read(file_handle, headers: true).each do |record|
			next unless record['Progress'].to_i.to_s == record['Progress']
			create_from_record(record)
		end
	end
	
	def self.create_from_record(record)
		return unless record.to_hash.values.select(&:present?).count > 13
		sr = SurveyResponse.create!(
			age_given: record['Age1'],
			age_cope: record['Age2cope'],
			klass_given: record['Class1'],
			klass_cope: record['Class2cope'],
			race_given: record['RaceEthnicity1'],
			race_cope: record['RaceEthnicity2cope'],
			religion_given: record['religion1'],
			religion_cope: record['religion2cope'],
			disability_given: record['Disability1'],
			disability_cope: record['Disability2cope'],
			neurodiversity_given: record['Neurodiversity1'],
			neurodiversity_cope: record['Neurodiversity2cope'],
			gender_given: record['Gender1'],
			gender_cope: record['Gender2cope'],
			lgbtq_given: record['LGBTQIA+1'],
			lgbtq_cope: record['LGBTQIA+2cope'],
			pronouns_given: record['Pronouns1_5_TEXT'],
			pronouns_feeling: record['Pronouns3feel'],
			pronouns_experience: record['Pronouns2experience'],
			affinity: record['IdentifyAffinity'],
			additional_notes: record['IdentityMore']
		)
	end

	def detect_themes
		ThemeExtractorJob.perform_later self
	end
			
	def detect_identities
		IDENTITY_ATTRIBUTES.each do |attr|
			IdentityExtractorJob.perform_later(self, attr)
		end
	end
			
	def next_response
		SurveyResponse.where("created_at > ?", self.created_at).order("created_at ASC").limit(1).first
	end
	
	def previous_response
		SurveyResponse.where("created_at < ?", self.created_at).order("created_at DESC").limit(1).first
	end

	private
	
	def sanitize_array_values	
		self.tags = tags.sort.reject(&:blank?)
		self.age_coping_tags = age_coping_tags.sort.reject(&:blank?)
		self.klass_coping_tags = klass_coping_tags.sort.reject(&:blank?)
		self.race_coping_tags = race_coping_tags.sort.reject(&:blank?)
		self.religion_coping_tags = religion_coping_tags.sort.reject(&:blank?)
		self.disability_coping_tags = disability_coping_tags.sort.reject(&:blank?)
		self.neurodiversity_coping_tags = neurodiversity_coping_tags.sort.reject(&:blank?)
		self.gender_coping_tags = gender_coping_tags.sort.reject(&:blank?)
		self.lgbtq_coping_tags = lgbtq_coping_tags.sort.reject(&:blank?)
	end
	
end
