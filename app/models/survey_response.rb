class SurveyResponse < ApplicationRecord

	require 'csv'
	
	# :age_given
	# :age_cope
	# :klass_given
	# :klass_cope
	# :race_given
	# :race_cope
	# :religion_given
	# :religion_cope
	# :disability_given
	# :disability_cope
	# :neurodiversity_given
	# :neurodiversity_cope
	# :gender_given
	# :gender_cope
	# :lgbtq_given
	# :lgbtq_cope
	# :pronouns_given
	# :pronouns_feeling
	# :pronouns_experience
	# :affinity
	# :additional_notes

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
	end

end
