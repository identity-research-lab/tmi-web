# A Case is a complete collection of answers given in response to the survey Questions.
class Case < ApplicationRecord

  require 'csv'
  require 'openai'

  validates_presence_of :response_id
  validates_uniqueness_of :response_id

  has_one :annotation, dependent: :destroy
  has_many :responses, dependent: :destroy

  # This should normally only be called as part of an asynchronous job.
  def self.from(record_id, record)
    if kase = Case.find_or_create_by(response_id: record_id)
		  Question.all.each do |question|
		    Response.create!(question_id: question.id, kase_id: kase.id, value: record[question.key])
		  end
      Services::ExportToGraph.perform(kase.id)
      return kase
    end
  end

  # Displays the query and its explanation for locating the Case's associated Persona in the graph.
  def graph_query
    {
      explainer: "Access and explore this participant's response data (and all of its relationships) as an Interactive Persona in the TMI-Graph app.",
      query: "MATCH (p:Persona)-[]-(n) WHERE p.permalink=\"#{permalink}\" RETURN p,n"
    }
  end

  # Convenience method to pad ID.
  def identifier
    self.id.to_s.rjust(4, "0")
  end

   # Calculates the permanent URL of the Case, which is stored as a property on the associated Persona.
  def permalink
    if Rails.env == "development"
      Rails.application.routes.url_helpers.url_for(controller: "cases", action: "show", host: "localhost", port: 3000, id: self.id)
    else
      Rails.application.routes.url_helpers.url_for(controller: "cases", action: "show", host: ENV.fetch("HOSTNAME", "localhost"), id: self.id)
    end
  end

  def reflections_corpus
    reflection_question_ids = Question.where(is_reflection: true).pluck(:id)
    responses.select{|r| reflection_question_ids.include? r.question_id}.map(&:value).join(". ")
  end

  # Calculates and sets the sentiment based on a the "identity reflection / notes" field.
  # This method uses the SentimentAnalysis service, passing the text of the reflection as an
  # argument. The service returns a classification, which is written to the Case record.
  def classify_sentiment
    if response = Services::SentimentAnalysis.perform(reflections_corpus)
      update_attribute :sentiment, response
      return response
    end
    return false
  end

  def generate_wordcloud
    return unless words = Services::GenerateWordCloud.perform(to_corpus)
    exploded_words = []
    words.each do |word|
      next unless word['frequency'] > 1
      word['frequency'].times{ exploded_words << word['word'] }
    end
    update_attribute :word_frequency, exploded_words
    return exploded_words
  end

  # Creates a WordCloudGeneratorJob and pushes in into the background job queue.
  def enqueue_wordcloud_generation
    WordCloudGeneratorJob.perform_async(self.id)
  end

  # Creates a KeywordExtractorJob and pushes it into the background job queue.
  def enqueue_keyword_extraction
    KeywordExtractorJob.perform_async(self.id)
  end

  # Creates a SentimentAnalysisJob and pushes it into the background job queue.
  def enqueue_sentiment_analysis
    SentimentAnalysisJob.perform_async(self.id)
  end

  # Compile all fields into a single body of text.
  def to_corpus
    responses.map(&:value).compact.join(". ")
  end

end
