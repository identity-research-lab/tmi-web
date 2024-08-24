# A SurveyResponse is a complete collection of answers given in response to the survey Questions.
# SurveyResponse objects are upserted when a survey data CSV file is imported.
class SurveyResponse < ApplicationRecord

  require 'csv'
  require 'openai'

  before_save :sanitize_array_values
  after_save_commit :export_to_graph
  after_create :enqueue_keyword_extraction
  after_create :enqueue_sentiment_analysis

  validates_presence_of :response_id
  validates_uniqueness_of :response_id

  REQUIRED_FIELDS = [:age_given]

  # This is the prompt passed to the AI agent to serve as instructions for sentiment analysis.
  SENTIMENT_PROMPT = %{
    You are a social science researcher doing textual analysis on survey data. Perform sentiment analysis against the provided text, classifying it as "positive", "negative", or "neutral". Return the classification encoded as JSON in the following format:

    {
      "sentiment" : "positive"
    }

    The text to perform sentiment analysis on is as follows:

  }


  # Given a file handle to a data file, parse the filel contents as CSV and hydrate SurveyResponse records in serial.
  def self.import(file_handle)
    CSV.read(file_handle, headers: true).each do |record|
      next unless record['Progress'].to_i.to_s == record['Progress']
      from(record)
    end
  end

  # Hydrates a SurveyResponse object from a record in the imported CSV data file.
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

  # Convenience method to pad ID.
  def identifier
    self.id.to_s.rjust(4, "0")
  end

  # Creates a KeywordExtractorJob and pushes it into the background job queue.
  def enqueue_keyword_extraction
    KeywordExtractorJob.perform_async(self.id)
  end

  # Creates a SentimentAnalysisJob and pushes it into the background job queue.
  def enqueue_sentiment_analysis
    SentimentAnalysisJob.perform_async(self.id)
  end

  # Invokes a service to update the graph databases from this SurveyResponse object.
  def export_to_graph
    ExportToGraph.perform(self.id)
  end
  
  # TODO move this to a service worker
  # Calculates and sets the sentiment based on a the "identity reflection / notes" field.
  # This method uses the Clients::OpenAi client passing the text of the reflection as an
  # argument to the prompt. The agent returns a classification, which is written to the
  # SurveyResponse record.
  def classify_sentiment
    response = Clients::OpenAi.request("#{SENTIMENT_PROMPT} #{self.notes}")
    return unless response['sentiment'].present?
    classification = response['sentiment'].strip.downcase
    update_attribute(:sentiment, classification)
    return classification
  end

  # Calculates the permanent URL of the SurveyResponse, which is stored as a property on the associated Persona.
  def permalink
    if Rails.env == "development"
      Rails.application.routes.url_helpers.url_for(controller: "survey_responses", action: "show", host: "localhost", port: 3000, id: self.id)
    else
      Rails.application.routes.url_helpers.url_for(controller: "survey_responses", action: "show", host: ENV.fetch("HOSTNAME", "localhost"), id: self.id)
    end
  end

  # TODO this belongs on the Persona
  # Displays the query and its explanation for locating the SurveyResponse's associated Persona in the graph.
  def graph_query
    {
      explainer: "Access and explore this participant's response data (and all of its relationships) as an Interactive Persona in the TMI-Graph app.",
      query: "MATCH (p:Persona)-[]-(n) WHERE p.permalink=\"#{permalink}\" RETURN p,n"
    }
  end

  private

  # TODO Clean this up
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
