# A Question is a representation of a survey question. 
# This class provides convenience methods for navigating question keys and labels, as well as selecting topical subsets of questions.
# For now, Questions are hardcoded and not persisted.
class Question

  attr_accessor :key, :label
  
  QUESTIONS = {
    age_given: "Age",
    age_exp: "Experience with Age",
    klass_given: "Class",
    klass_exp: "Experience with Class",
    race_ethnicity_given: "Race/Ethnicity",
    race_ethnicity_exp: "Experience with Race/Ethnicity",
    religion_given: "Religion",
    religion_exp: "Experience with Religion",
    disability_given: "Disability",
    disability_exp: "Experience with Disability",
    neurodiversity_given: "Neurodiversity",
    neurodiversity_exp: "Experience with Neurodiversity",
    gender_given: "Gender",
    gender_exp: "Experience with Gender",
    lgbtqia_given: "LGBTQIA+ Status",
    lgbtqia_exp: "Experience with LGBTQIA+",
    pronouns_given: "Pronouns Given",
    pronouns_exp: "Experience with Pronouns",
    pronouns_feel: "Pronoun Feelings",
    affinity: "Identity Affinities",
    notes: "Identity Reflection"
  }
  
  def self.from(key)
    new(key: key, label: QUESTIONS[key.to_sym])
  end

  def self.experience_questions
    QUESTIONS.keys.select{|k| k.to_s.include?("_exp")}
  end

  def self.identity_questions
    QUESTIONS.keys.select{|k| k.to_s.include?("_given")}
  end
  
  def self.freeform_questions
    [:pronouns_feel, :affinity, :notes]
  end
  
  def initialize(attrs={})
    self.key = attrs[:key]
    self.label = attrs[:label]
    self
  end
  
  def field
    self.label.gsub("class","klass").gsub("id","given")  
  end
  
  def codes_field
    "#{self.key}_codes".gsub("given","id")
  end
    
end
