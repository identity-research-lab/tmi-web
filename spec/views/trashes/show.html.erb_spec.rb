require 'rails_helper'

RSpec.describe "trashes/show", type: :view do
  before(:each) do
    assign(:trash, Trash.create!(
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
