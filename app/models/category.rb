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

  PROMPT = %{
    You are a social researcher doing data analysis. Please generate a list of the 20 most relevant themes from the following list of codes. The themes should be all lowercase and contain no punctuation. Codes should be stripped of quotation marks. Return each code with an array of its categories in JSON format. Use this JSON as the format:

    {
      "themes" : [
        {
          "theme": "foo",
          "codes": [ "bar", "bat", "baz"]
        }
      ]
    }

    The codes are as follows:
  }

  # Regenerates Category objects based on codes within a given context.
  # This method uses the Clients::OpenAi client passing the codes as an argument to the prompt.
  # The agent returns an array of themes, which are then captured as Category objects.
  #
  # @param context [String] the context value to use to filter codes for categorization.
  # @return [String] the JSON response returned by the API.

  def self.from(context)
    codes = Code.where(context: context)
    response = Clients::OpenAi.request("#{PROMPT} #{codes.map(&:name).join(',')}")
    return unless response['themes']

    Category.where(context: context).destroy_all

    response['themes'].each do |record|
      category = Category.find_or_create_by(name: record['theme'], context: context)
      codes.each do |code|
        next unless record['codes'].include?(code.name)
        CategorizedAs.create(from_node: category, to_node: code)
      end
    end

  end

  def self.histogram(context)
    where(context: context).inject({}) { |acc, category| acc[category.name] = category.codes.count; acc }
  end

end
