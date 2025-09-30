class Search

  include ActiveModel::API

  attr_accessor :query

  def initialize(query)
    self.query = query
  end

  def responses
    return [] unless self.query.present?
    @responses ||= Response.where("value LIKE ?", "%#{self.query}%").includes(:case)
  end

end
