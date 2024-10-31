class Response < ApplicationRecord

  after_update :enqueue_export_to_graph

  belongs_to :case
  belongs_to :question

  def codes
    @codes ||= Code.where(name: self.raw_codes)
  end

  private

    # Invokes a service to update the graph databases from the associated Case object.
    def enqueue_export_to_graph
      if case_id = Case.find(self.case_id).id
        ExportToGraphJob.perform_async(case_id)
      end
    end

end
