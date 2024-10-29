# A Context reflects a demographic category.
class Context < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :display_name
  validates_uniqueness_of :name

  has_many :questions

end
