class StatsController < ApplicationController

  def index

    sentiments = SurveyResponse.all.pluck(:sentiment)
    @pronoun_sentiment_positive = (sentiments.select{|sentiment| sentiment == "positive"}.count / sentiments.count.to_f * 100).to_i
    @pronoun_sentiment_neutral = (sentiments.select{|sentiment| sentiment == "neutral"}.count / sentiments.count.to_f * 100).to_i
    @pronoun_sentiment_negative = (sentiments.select{|sentiment| sentiment == "negative"}.count / sentiments.count.to_f * 100).to_i

    survey_response_count = SurveyResponse.count
    question_count = Question::QUESTIONS.count
    answer_count = survey_response_count * question_count
    persona_count = Persona.count
    identity_count = Identity.count
    code_count = Code.count
    category_count = Category.count
    keyword_count = Keyword.count

    @total_datapoints = survey_response_count + (question_count * survey_response_count) + identity_count + code_count + category_count + keyword_count + sentiments.compact.count

    @stats = {
      "Participant survey responses" => survey_response_count,
      "Survey questions" => question_count,
      "Survey answers" => answer_count,
      "Personas" => persona_count,
      "Self-expressed identities" => identity_count,
      "Codes" => code_count,
      "Derived categories" => category_count,
      "Derived Keywords" => keyword_count
    }
  end

end
