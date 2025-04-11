require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "users/new", type: :view do
  let(:company) { create(:company, name: "Test Company") }
  let(:user) { build(:user, company: company) }

  before do
    assign(:company, company)
    assign(:user, user)
  end

  context "when the form is rendered" do
    before { render }

    it "displays the correct header" do
      expect(rendered).to include("New User for Test Company")
    end

    it "renders the form fields" do
      expect(rendered).to have_css("form[action='#{company_users_path(company)}'][method='post']")
      expect(rendered).to have_field("user_display_name")
      expect(rendered).to have_field("user_email")
      expect(rendered).to have_field("user_username")
      expect(rendered).to have_button("Create User")
    end
  end

  context "when there are validation errors" do
    before do
      user.errors.add(:display_name, "can't be blank")
      user.errors.add(:email, "is invalid")
      user.errors.add(:username, "can't be blank")

      render
    end

    it "displays the error messages" do
      expect(CGI.unescapeHTML(rendered)).to include("Display name can't be blank")
      expect(CGI.unescapeHTML(rendered)).to include("Email is invalid")
      expect(CGI.unescapeHTML(rendered)).to include("Username can't be blank")
    end
  end
end