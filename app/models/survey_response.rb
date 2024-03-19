class SurveyResponse < ApplicationRecord

	require 'csv'
	
	QUESTION_MAPPING = {
		age_given: "Age",
		age_cope: "Age Experience",
		klass_given: "Class",
		klass_cope: "Class Experience",
		race_given: "Race/Ethnicity",
		race_cope: "Race/Ethnicity Experience",
		religion_given: "Religion",
		religion_cope: "Religion Experience",
		disability_given: "Disability",
		disability_cope: "Disability Experience",
		neurodiversity_given: "Neurodiversity",
		neurodiversity_cope: "Neurodiversity Experience",
		gender_given: "Gender",
		gender_cope: "Gender Experience",
		lgbtq_given: "LGBTQIA+ Status",
		lgbtq_cope: "LGBTQIA+ Experience",
		pronouns_given: "Pronouns Given",
		pronouns_feeling: "Pronoun Feelings",
		pronouns_experience: "Pronoun Experiences",
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
		SurveyResponse.create!(
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

	def answer_for(question_label)
		read_attribute(question_label)
	end
	
	def next_response
		SurveyResponse.where("created_at > ?", self.created_at).order("created_at ASC").limit(1).first
	end
	
	def previous_response
		SurveyResponse.where("created_at < ?", self.created_at).order("created_at DESC").limit(1).first
	end

end
