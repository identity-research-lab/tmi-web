class SurveyResponse < ApplicationRecord

	require 'csv'
	require 'openai'

	before_validation :sanitize_array_values
	after_create :queue_detect_themes
	after_save_commit :queue_export_to_graph
	
	validates_presence_of :response_id
	validates_uniqueness_of :response_id
	
	THEME_PROMPT = "Dear ChatGPT, as a qualitative researcher employing a narrative qualitative coding approach with a focus on intersectionality, your task is to identify and analyze themes within passages of text that reflect the multifaceted experiences of individuals across various social identities. Pay close attention to how different aspects of identity intersect and influence each other, and explore the complexities and nuances of lived experiences within diverse social contexts. Your analysis should aim to uncover underlying patterns, tensions, and intersections of power and oppression, shedding light on the interplay between social identities and shaping individuals' narratives. Please generate themes that represent the richness and depth of the data, highlighting the significance of intersectionality in understanding human experiences. Generated themes should be output as a single list of words or short phrases separated by commas with no other punctuation."

	def self.refresh_from_upload(file_handle)
		return unless file_handle
		CSV.read(file_handle, headers: true).each do |record|
			next unless record['Progress'].to_i.to_s == record['Progress']
			next unless record['age_given'].present?
			create_from_record(record)
		end
	end
	
	def self.create_from_record(record)

		sr = SurveyResponse.find_or_create_by(response_id: record['ResponseId'])

		pronouns_given = record['pronouns_given'] == "self-describe" ? "#{record['pronouns_given_5_TEXT']} (self-described)" : record['pronouns_given']
		
		sr.update(
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
			pronouns_given: pronouns_given,
			pronouns_exp: record['pronouns_exp'],
			pronouns_feel: record['pronouns_feel'],
			affinity: record['affinity'],
			notes: record['notes']
		)
		sr.save
	end

	def identifier
		self.id.to_s.rjust(4, "0")	
	end
	
	def queue_detect_themes
		ThemeExtractorJob.perform_later self
	end
			
	def queue_export_to_graph
		ExportToGraphJob.perform_later self
	end

	def to_graph

		if persona_to_flush = Persona.find_by(survey_response_id: id)
			persona_to_flush.destroy
		end
		
		persona = Persona.find_or_create_by(
			name: "Persona #{identifier}", 
			survey_response_id: id,
			permalink: permalink
		)
		
		themes.each do |theme|
			t = Theme.find_or_create_by(name: theme)
			RelatesTo.create(from_node: persona, to_node: t)
		end

		age_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag.strip, context: "age")
			Experiences.create(from_node: persona, to_node: tag)
		end

		klass_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag.strip, context: "class")
			Experiences.create(from_node: persona, to_node: tag)
		end
		race_ethnicity_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag.strip, context: "race-ethnicity")
			Experiences.create(from_node: persona, to_node: tag)
		end
		religion_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag.strip, context: "religion")
			Experiences.create(from_node: persona, to_node: tag)
		end
		disability_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag.strip, context: "disability")
			Experiences.create(from_node: persona, to_node: tag)
		end
		neurodiversity_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag.strip, context: "neurodiversity")
			Experiences.create(from_node: persona, to_node: tag)
		end
		gender_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag.strip, context: "gender")
			Experiences.create(from_node: persona, to_node: tag)
		
		end
		lgbtqia_exp_tags.each do |exp_tag| 
			tag = Tag.find_or_create_by(name: exp_tag.strip, context: "lgbtqia")
			Experiences.create(from_node: persona, to_node: tag)
		end
		
		pronouns_exp_tags.each do |exp_tag|
			tag = Tag.find_or_create_by(name: exp_tag, context: "pronouns")
			Experiences.create(from_node: persona, to_node: tag)
		end
		
		pronouns_feel_tags.each do |exp_tag|
			tag = Tag.find_or_create_by(name: exp_tag, context: "pronouns-feel")
			Experiences.create(from_node: persona, to_node: tag)
		end
		
		affinity_tags.each do |exp_tag|
			tag = Tag.find_or_create_by(name: exp_tag, context: "affinity")
			Experiences.create(from_node: persona, to_node: tag)
		end
		
		notes_tags.each do |exp_tag|
			tag = Tag.find_or_create_by(name: exp_tag, context: "notes")
			Experiences.create(from_node: persona, to_node: tag)
		end

		age_id_tags.each do |id_tag| 
			identity = Identity.find_or_create_by(name: id_tag, context: "age")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		klass_id_tags.each do |id_tag| 
			identity = Identity.find_or_create_by(name: id_tag, context: "class")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		race_ethnicity_id_tags.each do |id_tag| 
			identity = Identity.find_or_create_by(name: id_tag, context: "race/ethnicity")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		religion_id_tags.each do |id_tag| 
			identity = Identity.find_or_create_by(name: id_tag, context: "religion")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		gender_id_tags.each do |id_tag| 
			identity = Identity.find_or_create_by(name: id_tag, context: "gender")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		disability_id_tags.each do |id_tag| 
			identity = Identity.find_or_create_by(name: id_tag, context: "disability")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		neurodiversity_id_tags.each do |id_tag| 
			identity = Identity.find_or_create_by(name: id_tag, context: "neurodiversity")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		lgbtqia_id_tags.each do |id_tag| 
			identity = Identity.find_or_create_by(name: id_tag, context: "lgbtqia")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end

		pronouns_id_tags.each do |id_tag|
			identity = Identity.find_or_create_by(name: id_tag, context: "pronouns")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		
	end
	
	def permalink
		if Rails.env == "development"
			Rails.application.routes.url_helpers.url_for(controller: "survey_responses", action: "show", host: "localhost", port: 3000, id: self.id)
		else
			Rails.application.routes.url_helpers.url_for(controller: "survey_responses", action: "show", host: ENV.fetch("HOSTNAME", "localhost"), id: self.id)
		end
	end

	def graph_query
		"MATCH (p:Persona)-[]-(t) WHERE p.permalink=\"#{permalink}\" RETURN p,t"  
	end

	def corpus
		[self.age_exp, self.klass_exp, self.race_ethnicity_exp, self.religion_exp, self.disability_exp, self.neurodiversity_exp, self.gender_exp, self.lgbtqia_exp].join(' ')
	end
				
	def complete_enough?
		[self.age_given, self.klass_given, self.race_ethnicity_given, self.religion_given, self.disability_given, self.neurodiversity_given, self.gender_given, self.lgbtqia_given].reject(&:nil?).size > 0
	end
	
	private
	
	def sanitize_array_values	
		self.themes = themes.flatten.join(", ").split(", ").map(&:strip)

		self.age_exp_tags = age_exp_tags.join(", ").split(", ").map(&:strip)
		self.klass_exp_tags = klass_exp_tags.join(", ").split(", ").map(&:strip)
		self.race_ethnicity_exp_tags = race_ethnicity_exp_tags.join(", ").split(", ").map(&:strip)
		self.religion_exp_tags = religion_exp_tags.join(", ").split(", ").map(&:strip)
		self.disability_exp_tags = disability_exp_tags.join(", ").split(", ").map(&:strip)
		self.neurodiversity_exp_tags = neurodiversity_exp_tags.join(", ").split(", ").map(&:strip)
		self.gender_exp_tags = gender_exp_tags.join(", ").split(", ").map(&:strip)
		self.lgbtqia_exp_tags = lgbtqia_exp_tags.join(", ").split(", ").map(&:strip)

		self.age_id_tags = age_id_tags.join(", ").split(", ").map(&:strip)
		self.klass_id_tags = klass_id_tags.join(", ").split(", ").map(&:strip)
		self.race_ethnicity_id_tags = race_ethnicity_id_tags.join(", ").split(", ").map(&:strip)
		self.religion_id_tags = religion_id_tags.join(", ").split(", ").map(&:strip)
		self.disability_id_tags = disability_id_tags.join(", ").split(", ").map(&:strip)
		self.neurodiversity_id_tags = neurodiversity_id_tags.join(", ").split(", ").map(&:strip)
		self.gender_id_tags = gender_id_tags.join(", ").split(", ").map(&:strip)
		self.lgbtqia_id_tags = lgbtqia_id_tags.join(", ").split(", ").map(&:strip)
	end


end
