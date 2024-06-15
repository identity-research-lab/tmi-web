class SurveyResponse < ApplicationRecord

	require 'csv'
	require 'openai'

	before_validation :sanitize_array_values
	after_save_commit :enqueue_export_to_graph
	
	validates_presence_of :response_id
	validates_uniqueness_of :response_id
	
	def self.import(file_handle)
		CSV.read(file_handle, headers: true).each do |record|
			next unless record['Progress'].to_i.to_s == record['Progress']
			next unless record['age_given'].present?
			create_from_record(record)
		end
	end
	
	def self.create_from_record(record)

		sr = SurveyResponse.find_or_initialize_by(response_id: record['ResponseId'])

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
	end

	def identifier
		self.id.to_s.rjust(4, "0")	
	end
	
	def enqueue_export_to_graph
		ExportToGraphJob.perform_async(self.id)
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
		
		age_exp_codes.each do |exp_code| 
			code = Code.find_or_create_by(name: exp_code.strip, context: "age")
			Experiences.create(from_node: persona, to_node: code)
		end

		klass_exp_codes.each do |exp_code| 
			code = Code.find_or_create_by(name: exp_code.strip, context: "class")
			Experiences.create(from_node: persona, to_node: code)
		end
		race_ethnicity_exp_codes.each do |exp_code| 
			code = Code.find_or_create_by(name: exp_code.strip, context: "race-ethnicity")
			Experiences.create(from_node: persona, to_node: code)
		end
		religion_exp_codes.each do |exp_code| 
			code = Code.find_or_create_by(name: exp_code.strip, context: "religion")
			Experiences.create(from_node: persona, to_node: code)
		end
		disability_exp_codes.each do |exp_code| 
			code = Code.find_or_create_by(name: exp_code.strip, context: "disability")
			Experiences.create(from_node: persona, to_node: code)
		end
		neurodiversity_exp_codes.each do |exp_code| 
			code = Code.find_or_create_by(name: exp_code.strip, context: "neurodiversity")
			Experiences.create(from_node: persona, to_node: code)
		end
		gender_exp_codes.each do |exp_code| 
			code = Code.find_or_create_by(name: exp_code.strip, context: "gender")
			Experiences.create(from_node: persona, to_node: code)
		
		end
		lgbtqia_exp_codes.each do |exp_code| 
			code = Code.find_or_create_by(name: exp_code.strip, context: "lgbtqia")
			Experiences.create(from_node: persona, to_node: code)
		end
		
		pronouns_exp_codes.each do |exp_code|
			code = Code.find_or_create_by(name: exp_code, context: "pronouns")
			Experiences.create(from_node: persona, to_node: code)
		end
		
		pronouns_feel_codes.each do |exp_code|
			code = Code.find_or_create_by(name: exp_code, context: "pronouns-feel")
			Experiences.create(from_node: persona, to_node: code)
		end
		
		affinity_codes.each do |exp_code|
			code = Code.find_or_create_by(name: exp_code, context: "affinity")
			Experiences.create(from_node: persona, to_node: code)
		end
		
		notes_codes.each do |exp_code|
			code = Code.find_or_create_by(name: exp_code, context: "notes")
			Experiences.create(from_node: persona, to_node: code)
		end

		age_id_codes.each do |id_code| 
			identity = Identity.find_or_create_by(name: id_code, context: "age")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		klass_id_codes.each do |id_code| 
			identity = Identity.find_or_create_by(name: id_code, context: "class")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		race_ethnicity_id_codes.each do |id_code| 
			identity = Identity.find_or_create_by(name: id_code, context: "race/ethnicity")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		religion_id_codes.each do |id_code| 
			identity = Identity.find_or_create_by(name: id_code, context: "religion")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		gender_id_codes.each do |id_code| 
			identity = Identity.find_or_create_by(name: id_code, context: "gender")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		disability_id_codes.each do |id_code| 
			identity = Identity.find_or_create_by(name: id_code, context: "disability")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		neurodiversity_id_codes.each do |id_code| 
			identity = Identity.find_or_create_by(name: id_code, context: "neurodiversity")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end
		
		lgbtqia_id_codes.each do |id_code| 
			identity = Identity.find_or_create_by(name: id_code, context: "lgbtqia")
			IdentifiesWith.create(from_node: persona, to_node: identity)
		end

		pronouns_id_codes.each do |id_code|
			identity = Identity.find_or_create_by(name: id_code, context: "pronouns")
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
		{ 
			explainer: "// Return the persona (and all of its relations) that corresponds to this survey response.",
			query: "MATCH (p:Persona)-[]-(n) WHERE p.permalink=\"#{permalink}\" RETURN p,n"
		}
	end
				
	def complete_enough?
		[self.age_given, self.klass_given, self.race_ethnicity_given, self.religion_given, self.disability_given, self.neurodiversity_given, self.gender_given, self.lgbtqia_given].reject(&:nil?).size > 0
	end
	
	private
	
	def sanitize_array_values	
		self.age_exp_codes = age_exp_codes.join(", ").split(", ").map(&:strip)
		self.klass_exp_codes = klass_exp_codes.join(", ").split(", ").map(&:strip)
		self.race_ethnicity_exp_codes = race_ethnicity_exp_codes.join(", ").split(", ").map(&:strip)
		self.religion_exp_codes = religion_exp_codes.join(", ").split(", ").map(&:strip)
		self.disability_exp_codes = disability_exp_codes.join(", ").split(", ").map(&:strip)
		self.neurodiversity_exp_codes = neurodiversity_exp_codes.join(", ").split(", ").map(&:strip)
		self.gender_exp_codes = gender_exp_codes.join(", ").split(", ").map(&:strip)
		self.lgbtqia_exp_codes = lgbtqia_exp_codes.join(", ").split(", ").map(&:strip)
		self.pronouns_exp_codes =  pronouns_exp_codes.join(", ").split(", ").map(&:strip)
		self.pronouns_feel_codes =  pronouns_feel_codes.join(", ").split(", ").map(&:strip)

		self.pronouns_id_codes = pronouns_id_codes.join(", ").split(", ").map(&:strip)
		self.age_id_codes = age_id_codes.join(", ").split(", ").map(&:strip)
		self.klass_id_codes = klass_id_codes.join(", ").split(", ").map(&:strip)
		self.race_ethnicity_id_codes = race_ethnicity_id_codes.join(", ").split(", ").map(&:strip)
		self.religion_id_codes = religion_id_codes.join(", ").split(", ").map(&:strip)
		self.disability_id_codes = disability_id_codes.join(", ").split(", ").map(&:strip)
		self.neurodiversity_id_codes = neurodiversity_id_codes.join(", ").split(", ").map(&:strip)
		self.gender_id_codes = gender_id_codes.join(", ").split(", ").map(&:strip)
		self.lgbtqia_id_codes = lgbtqia_id_codes.join(", ").split(", ").map(&:strip)
	end


end
