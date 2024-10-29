# A Question is a representation of a survey question.
# This class provides convenience methods for navigating question keys and labels, as well as selecting topical subsets of questions.
# For now, Questions are hardcoded and not persisted.
class Question < ApplicationRecord

  has_many :responses
  belongs_to :context

  def self.from(key)
    new(key: key, label: QUESTIONS[key.to_sym])
  end

  def self.experience_questions
    Question.where(is_experience: true)
  end

  def self.identity_questions
    Question.where(is_identity: true)
  end

  def self.reflection_questions
    Question.where(is_reflection: true)
  end

  def codes_field
    "#{self.key}_codes".gsub("given","id")
  end


  def identity_field?
    self.key.include? "_given"
  end

  def experience_field?
    return true if self.key.include? "_exp"
    return true if self.key.include? "_feel"
    return true if self.key == "affinity"
    return true if self.key == "notes"
  end

end
