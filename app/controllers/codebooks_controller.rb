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
			@frequencies = Code.histogram(@context.gsub("_exp","").gsub("klass","class").gsub("_","-"))
		end

		if @context.include?("_exp")		
			@categories_histogram = Category.histogram(@context_key)
			@total_codes = @categories_histogram.values.sum
		end
		
	end
	
	def enqueue_categories
		context = params[:codebook_id].gsub("_given","").gsub("_exp","").gsub("klass","class").gsub("_","-")
		CategoryExtractorJob.perform_async(context)
		redirect_to( action: :show, id: params[:codebook_id], params: {enqueued_at: Time.now.strftime("%I:%M:%S %P (%Z)")} )
	end
	
end
