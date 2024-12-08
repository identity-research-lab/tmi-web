# A Context reflects a demographic category.
class Context < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :display_name
  validates_uniqueness_of :name

  has_many :questions

  def suggest_categories
    update_attribute(:suggested_categories, [])
    categories = Services::SuggestCategories.perform(self.id).map{|category| category['category'] }
    update_attribute(:suggested_categories, categories)
  end

  def primary_experience_question
    self.questions.find_by(is_experience: true)
  end

end
