class CodebooksController < ApplicationController
	
	USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }
	
	before_action :authenticate
	
	def authenticate
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

	def index
		@contexts = Question::QUESTIONS
	end
	
	def show
		@context = params[:id]
		@context_key = @context.gsub("_given","").gsub("_exp","").gsub("klass","class").gsub("_","-")
		@enqueued_at = params[:enqueued_at]

		sections = Question::QUESTIONS.keys
		@section_name = Question::QUESTIONS[@context.to_sym]
		@previous_section = sections[sections.index(@context.to_sym) - 1]
		@next_section = sections[sections.index(@context.to_sym) + 1]
		
		if params[:id].split('_').last == "given"
			@frequencies = Identity.histogram(@context.gsub("_given","").gsub("klass","class").gsub("_","/"))
		else
			@frequencies = Tag.histogram(@context.gsub("_exp","").gsub("klass","class").gsub("_","-"))
		end

		if @context.include?("_exp")		
			@categories_histogram = Category.where(context: @context_key).inject({}) { |acc, category| acc[category.name] = category.tags.count; acc }
			@total_codes = @categories_histogram.values.sum
		end
		
	end
	
	def enqueue_categories
		Category.enqueue_category_extractor_job(params[:codebook_id].gsub("_given","").gsub("_exp","").gsub("klass","class").gsub("_","-"))
		redirect_to( action: :show, id: params[:codebook_id], params: {enqueued_at: Time.now.strftime("%I:%M:%S %P (%Z)")} )
	end
	
end
