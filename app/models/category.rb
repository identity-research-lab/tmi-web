# A Category is a label applied to a group of related Codes within a provided context.
# For example, a category may refer to a subset of the codes related to "age".
# Categories are machine-derived. As such, they are influenced by biases in external training data.
# Careful human discernment of categories is required to identify and address these biases.
class Category

  include ActiveGraph::Node

  property :name
  property :context
  property :description

  validates :name, presence: true
  validates :context, presence: true
  validates_uniqueness_of :name, scope: :context
  
  has_many :out, :codes, rel_class: :Contains
  has_many :in, :themes, rel_class: :EmergesFrom

  # Generates a hash with the unique category name as the key and the count of its associated codes as a value.
  def self.histogram(context)
    categories = where(context: context).query_as(:c).with('c, count{(c)-[:CONTAINS]-(code:Code)} AS ct').return("c.name, ct").order('ct DESC')
    categories.inject({}) {|accumulator,category| accumulator[category.values[0]] ||= 0; accumulator[category.values[0]] += category.values[1]; accumulator}
  end

end
