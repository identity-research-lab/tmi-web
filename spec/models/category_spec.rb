require 'rails_helper'

RSpec.describe Category do

  before do
    allow(Category).to receive(:where).and_return(response)
  end

  let(:result_set) { Struct.new(:name, :codes) }
  let(:response) {
    [
      result_set.new(name: "generation", codes: ["code1", "code2"]),
      result_set.new(name: "cusp", codes: ["code3", "code4", "code5"]),
    ]
  }

  it "returns a histogram of codes and their counts"  do
    histogram = Category.histogram("age")
    expect(histogram["generation"]).to eq(2)
    expect(histogram["cusp"]).to eq(3)
  end

end
