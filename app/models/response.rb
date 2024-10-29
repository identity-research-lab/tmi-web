class Response < ApplicationRecord

  belongs_to :survey_response
  belongs_to :question

  def codes
    Code.where(name: self.raw_codes)
  end

end
