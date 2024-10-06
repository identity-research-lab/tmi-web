class StatsController < ApplicationController

  def index

    survey_response_count = SurveyResponse.count
    question_count = Question::QUESTIONS.count
    answer_count = survey_response_count * question_count
    persona_count = Persona.count
    identity_count = Identity.count
    code_count = Code.count
    category_count = Category.count
    keyword_count = Keyword.count
    node_count = ActiveGraph::Base.query('WITH count{()} AS ct RETURN ct').first.values.first
    edge_count = ActiveGraph::Base.query('WITH count{()-[]-()} AS ct RETURN ct').first.values.first

    sentiments = SurveyResponse.where("sentiment IS NOT NULL").pluck(:sentiment)
    if sentiments.any?
      @pronoun_sentiment_positive = (sentiments.select{|sentiment| sentiment == "positive"}.count / sentiments.count.to_f * 100).to_i
      @pronoun_sentiment_neutral = (sentiments.select{|sentiment| sentiment == "neutral"}.count / sentiments.count.to_f * 100).to_i
      @pronoun_sentiment_negative = (sentiments.select{|sentiment| sentiment == "negative"}.count / sentiments.count.to_f * 100).to_i
    else 
      @pronoun_sentiment_positive = 0
      @pronoun_sentiment_neutral = 0
      @pronoun_sentiment_negative = 0
    end
    
    @total_datapoints = survey_response_count + (question_count * survey_response_count) + identity_count + code_count + category_count + keyword_count + sentiments.count + edge_count

    @stats = {
      "Participant survey responses" => survey_response_count,
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
