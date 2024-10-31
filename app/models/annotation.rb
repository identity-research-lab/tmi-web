# An Annotation is a note or comment made by a researcher and attached to a Case.
class Annotation < ApplicationRecord

  validates_presence_of :case_id
  validates_presence_of :text

  belongs_to :case

end
