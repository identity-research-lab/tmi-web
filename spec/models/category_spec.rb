require 'rails_helper'

RSpec.describe Category do

  before do
    allow(Category).to receive_message_chain(:where, :query_as, :with, :where, :return, :order).and_return(response)
  end

  let(:result_set) { Struct.new(:values) }
  let(:response) {
    [
      result_set.new(values: ["generation", 4]),
      result_set.new(values: ["cusp", 6])
    ]
  }

  it "returns a histogram of codes and their counts"  do
    histogram = Category.histogram("age")
    expect(histogram["generation"]).to eq(4)
    expect(histogram["cusp"]).to eq(6)
  end

end
