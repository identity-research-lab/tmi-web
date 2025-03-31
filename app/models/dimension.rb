# A Dimension reflects a demographic category.
class Dimension < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :display_name
  validates_uniqueness_of :name

  has_many :questions

  def categories
    @categories ||= Category.where(dimension: self.name).order(:name)
  end

  def codes
    @codes ||= Code.where(dimension: self.name).order(:name)
  end

  def suggest_categories
    update_attribute(:suggested_categories, [])
    categories = Services::SuggestCategories.perform(self.id).map{|category| category['category'] }
    update_attribute(:suggested_categories, categories)
  end

end
