class ExportToGraph

	attr_accessor :survey_response

	def self.perform(survey_response_id)
		new(survey_response_id).perform
	end

	def initialize(survey_response_id)
		@survey_response = SurveyResponse.find(survey_response_id)
	end

	def perform
		return false unless survey_response
		Persona.find_or_initialize_by(survey_response_id: survey_response.id).destroy
		populate_experience_codes
		populate_id_codes
		return true
	end

	private

	# Hydrates the associated Persona with data from the SurveyResponse.
	# Note that this operation is destructive to a Persona that already exists.
	def persona
		@persona ||= Persona.find_or_create_by(
			name: "Persona #{survey_response.identifier}",
			survey_response_id: survey_response.id,
			permalink: survey_response.permalink
		)
	end

	def populate_experience_codes
		contexts_and_codes = {
			"age" => survey_response.age_exp_codes,
			"class" => survey_response.klass_exp_codes,
			"race-ethnicity" => survey_response.race_ethnicity_exp_codes,
			"religion" => survey_response.religion_exp_codes,
			"disability" => survey_response.disability_exp_codes,
			"neurodiversity" => survey_response.neurodiversity_exp_codes,
			"gender" => survey_response.gender_exp_codes,
			"lgbtqia" => survey_response.lgbtqia_exp_codes,
			"pronouns" => survey_response.pronouns_exp_codes,
			"pronouns-feel" => survey_response.pronouns_feel_codes,
			"affinity" => survey_response.affinity_codes,
			"notes" => survey_response.notes_codes
		}
		contexts_and_codes.each do |context, codes|
			codes.compact.uniq.each do |name|
				code = Code.find_or_create_by(name: name.strip.downcase, context: context)
				next unless code.valid?
				Experiences.create(from_node: persona, to_node: code)
			end
		end

	end

	def populate_id_codes
		contexts_and_codes = {
			"age" => survey_response.age_id_codes,
			"class" => survey_response.klass_id_codes,
			"race-ethnicity" => survey_response.race_ethnicity_id_codes,
			"religion" => survey_response.religion_id_codes,
			"disability" => survey_response.disability_id_codes,
			"neurodiversity" => survey_response.neurodiversity_id_codes,
			"gender" => survey_response.gender_id_codes,
			"lgbtqia" => survey_response.lgbtqia_id_codes,
			"pronouns" => survey_response.pronouns_id_codes
		}
		contexts_and_codes.each do |context, codes|
			codes.compact.each do |name|
				identity = Identity.find_or_create_by(name: name.strip, context: context)
				next unless identity.valid?
				IdentifiesWith.create(from_node: persona, to_node: identity)
			end
		end
	end

end
