class PopulateResponses < ActiveRecord::Migration[7.2]
  def up
    SurveyResponse.all.each do |survey_response|
      Response.create(question_id: Question.find_by(key: 'age_given').id, survey_response_id: survey_response.id, value: survey_response.age_given, raw_codes: survey_response.age_id_codes)
      Response.create(question_id: Question.find_by(key: 'age_exp').id, survey_response_id: survey_response.id, value: survey_response.age_exp, raw_codes: survey_response.age_exp_codes)
      Response.create(question_id: Question.find_by(key: 'klass_given').id, survey_response_id: survey_response.id, value: survey_response.klass_given, raw_codes: survey_response.klass_id_codes)
      Response.create(question_id: Question.find_by(key: 'klass_exp').id, survey_response_id: survey_response.id, value: survey_response.klass_exp, raw_codes: survey_response.klass_exp_codes)
      Response.create(question_id: Question.find_by(key: 'race_ethnicity_given').id, survey_response_id: survey_response.id, value: survey_response.race_ethnicity_given, raw_codes: survey_response.race_ethnicity_id_codes)
      Response.create(question_id: Question.find_by(key: 'race_ethnicity_exp').id, survey_response_id: survey_response.id, value: survey_response.race_ethnicity_exp, raw_codes: survey_response.race_ethnicity_exp_codes)
      Response.create(question_id: Question.find_by(key: 'religion_given').id, survey_response_id: survey_response.id, value: survey_response.religion_given, raw_codes: survey_response.religion_id_codes)
      Response.create(question_id: Question.find_by(key: 'religion_exp').id, survey_response_id: survey_response.id, value: survey_response.religion_exp, raw_codes: survey_response.religion_exp_codes)
      Response.create(question_id: Question.find_by(key: 'disability_given').id, survey_response_id: survey_response.id, value: survey_response.disability_given, raw_codes: survey_response.disability_id_codes)
      Response.create(question_id: Question.find_by(key: 'disability_exp').id, survey_response_id: survey_response.id, value: survey_response.disability_exp, raw_codes: survey_response.disability_exp_codes)
      Response.create(question_id: Question.find_by(key: 'neurodiversity_given').id, survey_response_id: survey_response.id, value: survey_response.neurodiversity_given, raw_codes: survey_response.neurodiversity_id_codes)
      Response.create(question_id: Question.find_by(key: 'neurodiversity_exp').id, survey_response_id: survey_response.id, value: survey_response.neurodiversity_exp, raw_codes: survey_response.neurodiversity_exp_codes)
      Response.create(question_id: Question.find_by(key: 'gender_given').id, survey_response_id: survey_response.id, value: survey_response.gender_given, raw_codes: survey_response.gender_id_codes)
      Response.create(question_id: Question.find_by(key: 'gender_exp').id, survey_response_id: survey_response.id, value: survey_response.gender_exp, raw_codes: survey_response.gender_exp_codes)
      Response.create(question_id: Question.find_by(key: 'lgbtqia_given').id, survey_response_id: survey_response.id, value: survey_response.lgbtqia_given, raw_codes: survey_response.lgbtqia_id_codes)
      Response.create(question_id: Question.find_by(key: 'lgbtqia_exp').id, survey_response_id: survey_response.id, value: survey_response.lgbtqia_exp, raw_codes: survey_response.lgbtqia_exp_codes)
      Response.create(question_id: Question.find_by(key: 'pronouns_given').id, survey_response_id: survey_response.id, value: survey_response.pronouns_given, raw_codes: survey_response.pronouns_id_codes)
      Response.create(question_id: Question.find_by(key: 'pronouns_exp').id, survey_response_id: survey_response.id, value: survey_response.pronouns_exp, raw_codes: survey_response.pronouns_exp_codes)
      Response.create(question_id: Question.find_by(key: 'pronouns_feel').id, survey_response_id: survey_response.id, value: survey_response.pronouns_feel, raw_codes: survey_response.pronouns_feel_codes)
      Response.create(question_id: Question.find_by(key: 'affinity').id, survey_response_id: survey_response.id, value: survey_response.affinity, raw_codes: survey_response.affinity_codes)
      Response.create(question_id: Question.find_by(key: 'notes').id, survey_response_id: survey_response.id, value: survey_response.notes, raw_codes: survey_response.notes_codes)
    end
  end

  def down
    Response.destroy_all
  end

end

