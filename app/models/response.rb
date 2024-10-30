class Response < ApplicationRecord

  after_update :enqueue_export_to_graph

  belongs_to :survey_response
  belongs_to :question

  def codes
    @codes ||= Code.where(name: self.raw_codes)
  end

  private

    # Invokes a service to update the graph databases from the associated SurveyResponse object.
    def enqueue_export_to_graph
      if survey_response_id = SurveyResponse.find(self.survey_response_id).id
        ExportToGraphJob.perform_async(survey_response_id)
      end
    end

end
