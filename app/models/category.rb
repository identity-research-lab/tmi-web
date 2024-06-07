class Category

	require 'csv'
	
	include ActiveGraph::Node
	
	property :name
	property :context
	
	validates :name, presence: true
	validates :context, presence: true

	has_many :in, :tags, rel_class: :CategorizesAs

	PROMPT_INITIALIZE = %{ 
		You are a social researcher doing data analysis. Please generate categories from the following list of codes. The categories should be all lower case. Then place each code in one or more of the categories. Do not return any categories that only have one tag. Export the data as a comma-separated-value list, with the first column being the category and the second column being a comma-separated list of tags. Make sure that the syntax of the CSV file is parseable by Ruby, For example: 

"category1","tag1","tag2","tag3",
"category2","tag3",
"category2","tag1","tag2",
		
		The tags are as follows: 
	}

	def self.from_context(context)
		tags = Tag.where(context: context)
		client = OpenAI::Client.new
		if response = client.chat( parameters: { model: "gpt-3.5-turbo", 
			messages: [{ 
				role: "user", 
				content: "#{PROMPT_INITIALIZE} #{tags.map(&:name).join(",")}"
			}], temperature: 0.7 } )	

			data = response.dig("choices", 0, "message", "content")

			categories = {}
			CSV.parse(data).each do |row|
				values = row[1..-1].compact.uniq.sort
				next unless values.count > 2
				categories[row[0]] = values
			end

			Category.where(context: context).destroy_all
			categories.each do |k,v|
				category = Category.create(name: k, context: context)
				tags.select{ |t| v.include?(t.name) }.each{ |t| CategorizesAs.create(from_node: category, to_node: t) }
			end

		end	

	end

end 
