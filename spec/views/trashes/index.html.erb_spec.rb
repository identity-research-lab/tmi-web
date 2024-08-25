require 'rails_helper'

RSpec.describe "trashes/index", type: :view do
  before(:each) do
    assign(:trashes, [
      Trash.create!(
        name: "Name"
      ),
      Trash.create!(
        name: "Name"
      )
    ])
  end

  it "renders a list of trashes" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  end
end
