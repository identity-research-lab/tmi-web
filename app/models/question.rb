# A Question is a representation of a survey question.
# This class provides convenience methods for navigating question keys and labels, as well as selecting topical subsets of questions.
# For now, Questions are hardcoded and not persisted.
class Question < ApplicationRecord

  has_many :responses
  belongs_to :dimension

  def self.experience_questions
    Question.where(is_experience: true)
  end

  def self.identity_questions
    Question.where(is_identity: true)
  end

  def self.reflection_questions
    Question.where(is_reflection: true)
  end

end
