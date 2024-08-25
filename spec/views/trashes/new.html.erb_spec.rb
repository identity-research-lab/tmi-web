require 'rails_helper'

RSpec.describe "trashes/new", type: :view do
  before(:each) do
    assign(:trash, Trash.new(
      name: "MyString"
    ))
  end

  it "renders new trash form" do
    render

    assert_select "form[action=?][method=?]", trashes_path, "post" do

      assert_select "input[name=?]", "trash[name]"
    end
  end
end
