# A Category is a label applied to a group of related Codes within a provided context.
# For example, a category may refer to a subset of the codes related to "age".
# Categories are machine-derived. As such, they are influenced by biases in external training data.
# Careful human discernment of categories is required to identify and address these biases.
class Category

  include ActiveGraph::Node

  property :name
  property :context

  validates :name, presence: true
  validates :context, presence: true

  has_many :out, :codes, rel_class: :CategorizedAs, dependent: :delete_orphans

  # Regenerates Category objects based on codes within a given context.
  # This method uses the Clients::OpenAi client passing the codes as an argument to the prompt.
  # The agent returns an array of themes, which are then captured as Category objects.
  def self.from(context)
    codes = Code.where(context: context)
    return unless codes.any?

    text = codes.map(&:name).join(',')
    return unless text.present?
    return unless themes = DeriveThemes.perform(text)

    Category.where(context: context).destroy_all

    themes.each do |theme|
      category = Category.find_or_create_by(name: theme['theme'].strip.downcase, context: context)
      codes.each do |code|
        next unless theme['codes'].include?(code.name)
        CategorizedAs.create(from_node: category, to_node: code)
      end
    end

  end

  # Generates a hash with the unique category name as the key and the count of its associated codes as a value.
  def self.histogram(context)
    context = Question.from(context).context
    categories = where(context: context).query_as(:c).with('c, count{(c)-[:CATEGORIZED_AS]-(code:Code)} AS count').return("c.name, count").order('count DESC')
    categories.inject({}) {|accumulator,category| accumulator[category.values[0]] ||= 0; accumulator[category.values[0]] += category.values[1]; accumulator}
  end

end
