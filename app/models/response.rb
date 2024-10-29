class Response < ApplicationRecord

  belongs_to :survey_response
  belongs_to :question

end
