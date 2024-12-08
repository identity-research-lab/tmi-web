class StatisticsController < ApplicationController

  def index

    case_count = Case.count
    question_count = Question.all.count
    answer_count = case_count * question_count
    persona_count = Persona.count
    identity_count = Identity.count
    code_count = Code.count
    category_count = Category.count
    keyword_count = Keyword.count
    node_count = ActiveGraph::Base.query('WITH count{()} AS ct RETURN ct').first.values.first
    edge_count = ActiveGraph::Base.query('WITH count{()-[]-()} AS ct RETURN ct').first.values.first

    sentiments = Case.where("sentiment IS NOT NULL").pluck(:sentiment)
    if sentiments.any?
      @pronoun_sentiment_positive = (sentiments.select{|sentiment| sentiment == "positive"}.count / sentiments.count.to_f * 100).to_i
      @pronoun_sentiment_neutral = (sentiments.select{|sentiment| sentiment == "neutral"}.count / sentiments.count.to_f * 100).to_i
      @pronoun_sentiment_negative = (sentiments.select{|sentiment| sentiment == "negative"}.count / sentiments.count.to_f * 100).to_i
    else
      @pronoun_sentiment_positive = 0
      @pronoun_sentiment_neutral = 0
      @pronoun_sentiment_negative = 0
    end

    @total_datapoints = case_count + (question_count * case_count) + identity_count + code_count + category_count + keyword_count + sentiments.count + edge_count

    word_frequencies = Case.all.pluck(:word_frequency).flatten.compact
    @word_cloud_histogram = word_frequencies.tally.reject{|k,v| v < 20}

    @stats = {
      "Cases" => case_count,
      "Survey questions" => question_count,
      "Survey answers" => answer_count,
      "Personas" => persona_count,
      "Self-expressed identities" => identity_count,
      "Codes" => code_count,
      "Derived categories" => category_count,
      "Derived keywords" => keyword_count,
      "Graph nodes" => node_count,
      "Graph edges" => edge_count
    }
  end

end
