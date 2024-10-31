# An Annotation is a note or comment made by a researcher and attached to a Survey Response.
class Annotation < ApplicationRecord

  validates_presence_of :survey_response_id
  validates_presence_of :text

  belongs_to :case

end
