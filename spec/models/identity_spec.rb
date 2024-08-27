require 'rails_helper'

RSpec.describe Identity do

  before do
    allow(Identity).to receive_message_chain(:where, :query_as, :with, :return, :order).and_return(response)
  end

  let(:result_set) { Struct.new(:values) }
  let(:response) {
    [
      result_set.new(values: ["52", 4]),
      result_set.new(values: ["23", 6])
    ]
  }

  it "returns a histogram of codes and their counts"  do
    histogram = Identity.histogram("age")
    expect(histogram["52"]).to eq(4)
    expect(histogram["23"]).to eq(6)
  end

end
