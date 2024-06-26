class SurveyResponse < ApplicationRecord

  require 'csv'
  require 'openai'

  before_save :sanitize_array_values
  after_save_commit :enqueue_export_to_graph
  after_create :enqueue_keyword_extraction
  
  validates_presence_of :response_id
  validates_uniqueness_of :response_id

  REQUIRED_FIELDS = [:age_given]

  def self.import(file_handle)
    CSV.read(file_handle, headers: true).each do |record|
      next unless record['Progress'].to_i.to_s == record['Progress']
      from(record)
    end
  end

  def self.from(record)
     return unless REQUIRED_FIELDS.select{ |field| record[field.to_s].present? }.count == REQUIRED_FIELDS.count

    pronouns_given = record['pronouns_given'] == "self-describe" ? "#{record['pronouns_given_5_TEXT']} (self-described)" : record['pronouns_given']
    survey_response = SurveyResponse.find_or_initialize_by(response_id: record['ResponseId'])
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

  def enqueue_keyword_extraction
    KeywordExtractorJob.perform_async(self.id)
  end

  def enqueue_export_to_graph
    ExportToGraphJob.perform_async(self.id)
  end

  def to_graph
    Persona.find_or_initialize_by(survey_response_id: id).destroy
    populate_experience_codes
    populate_id_codes
    enqueue_keyword_extraction
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

  private

  def persona
    @persona ||= Persona.find_or_create_by(
      name: "Persona #{identifier}",
      survey_response_id: id,
      permalink: permalink
    )
  end

  def populate_experience_codes
    {
      "age" => age_exp_codes,
      "class" => klass_exp_codes,
      "race-ethnicity" => race_ethnicity_exp_codes,
      "religion" => religion_exp_codes,
      "disability" => disability_exp_codes,
      "neurodiversity" => neurodiversity_exp_codes,
      "gender" => gender_exp_codes,
      "lgbtqia" => lgbtqia_exp_codes,
      "pronouns" => pronouns_exp_codes,
      "pronouns-feel" => pronouns_feel_codes,
      "affinity" => affinity_codes,
      "notes" => notes_codes
    }.each do |context, codes|
      codes.each do |name|
        code = Code.find_or_create_by(name: name, context: context)
        Experiences.create(from_node: persona, to_node: code)
      end
    end

  end

  def populate_id_codes
    {
      "age" => age_id_codes,
      "class" => klass_id_codes,
      "race-ethnicity" => race_ethnicity_id_codes,
      "religion" => religion_id_codes,
      "disability" => disability_id_codes,
      "neurodiversity" => neurodiversity_id_codes,
      "gender" => gender_id_codes,
      "lgbtqia" => lgbtqia_id_codes,
      "pronouns" => pronouns_id_codes
    }.each do |context, codes|
      codes.each do |name|
        identity = Identity.find_or_create_by(name: name, context: context)
        IdentifiesWith.create(from_node: persona, to_node: identity)
      end
    end
  end

  def sanitize_array_values
    self.age_exp_codes = age_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.klass_exp_codes = klass_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.race_ethnicity_exp_codes = race_ethnicity_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.religion_exp_codes = religion_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.disability_exp_codes = disability_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.neurodiversity_exp_codes = neurodiversity_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.gender_exp_codes = gender_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.lgbtqia_exp_codes = lgbtqia_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.pronouns_exp_codes =  pronouns_exp_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.pronouns_feel_codes =  pronouns_feel_codes.join(", ").split(", ").map(&:strip).map(&:downcase)

    self.pronouns_id_codes = pronouns_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.age_id_codes = age_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.klass_id_codes = klass_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.race_ethnicity_id_codes = race_ethnicity_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.religion_id_codes = religion_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.disability_id_codes = disability_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.neurodiversity_id_codes = neurodiversity_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.gender_id_codes = gender_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
    self.lgbtqia_id_codes = lgbtqia_id_codes.join(", ").split(", ").map(&:strip).map(&:downcase)
  end


end
