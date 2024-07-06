class Code
  include ActiveGraph::Node

  property :name
  property :context

  before_validation :strip_whitespace
  before_validation :downcase

  validates :name, presence: true
  validates :context, presence: true
  validates_uniqueness_of :name, :scope => :context

  has_many :out, :personas, rel_class: :Experiences
  has_many :in, :categories, rel_class: :CategorizedAs

  def self.histogram(context)
    context = context.gsub("_exp","").gsub("klass","class").gsub("_","-")
    where(context: context).query_as(:t).with('t, count{(t)-[:EXPERIENCES]-()} AS c').where('c > 0').order('c DESC').return('t.name, c').inject({}) {|h,t| h[t.values[0]] ||= 0; h[t.values[0]] += t.values[1]; h}
  end

  private

  def strip_whitespace
    self.name.strip!
  end

  def downcase
    self.name.downcase!
  end
end
