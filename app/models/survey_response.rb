class SurveyResponse < ApplicationRecord

	require 'csv'
	require 'openai'

	before_validation :sanitize_array_values
	after_create :detect_themes
		
	validates_presence_of :response_id
	validates_uniqueness_of :response_id
	
	THEME_PROMPT = "What themes are present in the following text? Be specific. Please answer with a simple comma-separated list."
	
	IDENTITY_PROMPT = "Provide a single comma-separated list of all noun and adjectival phrases from the following text. Do not substitute any words. The text is as follows: "
	
	IDENTITY_ATTRIBUTES = [:age_given, :klass_given, :race_given, :religion_given, :disability_given, :neurodiversity_given, :gender_given, :lgbtqia_given]
	
	QUESTION_MAPPING = {
		age_given: "Age",
		age_exp: "Experience with Age",
		klass_given: "Class",
		klass_exp: "Experience with Class",
		race_ethnicity_given: "Race/Ethnicity",
		race_ethnicity_exp: "Experience with Race/Ethnicity",
		religion_given: "Religion",
		religion_exp: "Experience with Religion",
		disability_given: "Disability",
		disability_exp: "Experience with Disability",
		neurodiversity_given: "Neurodiversity",
		neurodiversity_exp: "Experience with Neurodiversity",
		gender_given: "Gender",
		gender_exp: "Experience with Gender",
		lgbtqia_given: "LGBTQIA+ Status",
		lgbtqia_exp: "Experience with LGBTQIA+",
		pronouns_given: "Pronouns Given",
		pronouns_exp: "Experience with Pronouns",
		pronouns_feel: "Pronoun Feelings",
		affinity: "Identity Affinities",
		notes: "Other Notes"
	}

	def self.refresh_from_upload(file_handle)
		return unless file_handle
		CSV.read(file_handle, headers: true).each do |record|
			next unless record['Progress'].to_i.to_s == record['Progress']
			create_from_record(record)
		end
	end
	
	def self.create_from_record(record)
		return unless record.to_hash.values.select(&:present?).count > 13
		return if SurveyResponse.find_by(response_id: record['ResponseId'])

		sr = SurveyResponse.create!(
			response_id: record['ResponseId'],
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
			pronouns_given: record['pronouns_given'],
			pronouns_exp: record['pronouns_exp'],
			pronouns_feel: record['pronouns_feel'],
			affinity: record['affinity'],
			notes: record['notes']
		)
	end

	def self.queue_export_to_neo4j
		all.each do |sr|
			PersonaToGraphJob.perform_later sr
		end
	end
	
	def to_graph
		p = Persona.find_or_create_by(name: "Persona #{id}", survey_response_id: id)
		themes.each do |theme|
			t = Theme.find_or_create_by(name: theme)
			RelatesTo.create(from_node: p, to_node: t)
		end
		age_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag)
			Experiences.create(from_node: p, to_node: tag)
		end
		p.save
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
		self.themes = themes.flatten.join(", ").split(", ")
		self.age_exp_tags = age_exp_tags.join(", ").split(", ")
		self.klass_exp_tags = klass_exp_tags.join(", ").split(", ")
		self.race_ethnicity_exp_tags = race_ethnicity_exp_tags.join(", ").split(", ").flatten
		self.religion_exp_tags = religion_exp_tags.join(", ").split(", ")
		self.disability_exp_tags = disability_exp_tags.join(", ").split(", ")
		self.neurodiversity_exp_tags = neurodiversity_exp_tags.join(", ").split(", ").flatten
		self.gender_exp_tags = gender_exp_tags.join(", ").split(", ")
		self.lgbtqia_exp_tags = lgbtqia_exp_tags.join(", ").split(", ")
	end

end
