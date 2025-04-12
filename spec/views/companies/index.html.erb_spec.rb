require 'rails_helper'

RSpec.describe "companies/index", type: :view do
  before do
    assign(:companies, [
             Company.create!(
               name: "Name"
             ),
             Company.create!(
               name: "Name"
             )
           ])

    render
  end

  it "renders a list of companies" do
    assert_select "tr>td", text: "Name", count: 2
  end
end
