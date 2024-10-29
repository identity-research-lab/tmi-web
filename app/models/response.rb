class Response < ApplicationRecord

  # TODO I need this to run under normal circumstances but NOT during the db migration that creates the records.
  after_save_commit :enqueue_export_to_graph

  belongs_to :survey_response
  belongs_to :question

  def codes
    Code.where(name: self.raw_codes)
  end

  private

    # Invokes a service to update the graph databases from the associated SurveyResponse object.
    def enqueue_export_to_graph
      ExportToGraphJob.perform_async(self.survey_response_id)
    end

end
