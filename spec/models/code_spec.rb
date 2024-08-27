require 'rails_helper'

RSpec.describe Code do

  before do
    allow(Code).to receive_message_chain(:where, :query_as, :with, :where, :order, :return).and_return(response)
  end

  let(:result_set) { Struct.new(:values) }
  let(:response) {
    [
      result_set.new(values: ["genx", 4]),
      result_set.new(values: ["genz", 6])
    ]
  }

  it "returns a histogram of codes and their counts"  do
    histogram = Code.histogram("age")
    expect(histogram["genx"]).to eq(4)
    expect(histogram["genz"]).to eq(6)
  end

end
