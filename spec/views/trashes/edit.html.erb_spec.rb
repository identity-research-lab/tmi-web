require 'rails_helper'

RSpec.describe "trashes/edit", type: :view do
  let(:trash) {
    Trash.create!(
      name: "MyString"
    )
  }

  before(:each) do
    assign(:trash, trash)
  end

  it "renders the edit trash form" do
    render

    assert_select "form[action=?][method=?]", trash_path(trash), "post" do

      assert_select "input[name=?]", "trash[name]"
    end
  end
end
