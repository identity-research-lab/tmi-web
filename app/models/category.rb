class Category

	include ActiveGraph::Node
	
	property :name
	property :context
	
	validates :name, presence: true
	validates :context, presence: true

	has_many :in, :tags, rel_class: :CategorizesAs

	PROMPT_INITIALIZE = %{ 
		You are a social researcher doing data analysis. Please generate a list of the 20 most relevant categories from the following list of codes. The categories should be all lower case. Categories should be lower-case and contain no punctuation. Codes should be stripped of quotation marks. Return each code with an array of its categories in JSON format. Use this JSON as the format:
		
		{ 
			"categories" : [
				{ 
					"category": "foo",
					"codes": [ "bar", "bat", "baz"]
				}
			]
		}
		
		The codes are as follows: 
	}

	def self.enqueue_category_extractor_job(context)
		CategoryExtractorJob.perform_async(context)
	end

	def self.from_context(context)
		tags = Tag.where(context: context)
		client = OpenAI::Client.new
	
		response = client.chat(
			parameters: {
				model: "gpt-4o",
				response_format: { type: "json_object" },
				messages: [{ role: "user", content: "#{PROMPT_INITIALIZE} #{tags.map(&:name).join(",")}" }],
				temperature: 0.7,
			}
		)	

		p response.dig("choices", 0, "message", "content")
		data = JSON.parse(response.dig("choices", 0, "message", "content"))['categories']

		Category.where(context: context).destroy_all

		data.each do |record|
			record['codes'].each do |v|
				category = Category.find_or_create_by(name: record['category'], context: context)
				tags.select{ |tag| record['codes'].include? tag.name }.each{ |tag| CategorizesAs.create(from_node: category, to_node: tag )}
			end
		end

	end

end 
