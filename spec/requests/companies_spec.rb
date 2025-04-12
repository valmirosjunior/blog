require 'rails_helper'

RSpec.describe "/companies", type: :request do
  let(:valid_attributes) { { name: "Test Company" } }
  let(:invalid_attributes) { { name: "" } }

  let!(:company) { create(:company, name: "Test Company") }
  let!(:users) { create_list(:user, 3, company: company) }

  describe "GET /index" do
    before { get companies_url }

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    before { get company_url(company) }

    it "renders a successful response" do
      expect(response).to be_successful
    end

    it "displays company details and associated users" do
      expect(response.body).to include(company.name)

      users.each do |user|
        expect(response.body).to include(user.display_name)
        expect(response.body).to include(user.email)
        expect(response.body).to include(user.username)
      end
    end

    it "includes links to edit and delete users" do
      users.each do |user|
        expect(response.body).to include(edit_company_user_path(company, user))
        expect(response.body).to include(company_user_path(company, user))
      end
    end
  end

  describe "GET /new" do
    before { get new_company_url }

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    before { get edit_company_url(company) }

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Company" do
        expect do
          post companies_url, params: { company: valid_attributes }
        end.to change(Company, :count).by(1)
      end

      it "redirects to the created company" do
        post companies_url, params: { company: valid_attributes }

        expect(response).to redirect_to(company_url(Company.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Company" do
        expect do
          post companies_url, params: { company: invalid_attributes }
        end.not_to change(Company, :count)
      end

      it "renders a response with status 422 (unprocessable entity)" do
        post companies_url, params: { company: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) { { name: "Updated Company Name" } }

    context "with valid parameters" do
      before { patch company_url(company), params: { company: new_attributes } }

      it "updates the requested company" do
        company.reload
        expect(company.name).to eq("Updated Company Name")
      end

      it "redirects to the company" do
        expect(response).to redirect_to(company_url(company))
      end
    end

    context "with invalid parameters" do
      before { patch company_url(company), params: { company: invalid_attributes } }

      it "does not update the company" do
        company.reload
        expect(company.name).to eq("Test Company") # Name should remain unchanged
      end

      it "renders a response with status 422 (unprocessable entity)" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when the company has no associated users" do
      let!(:company_without_users) { create(:company) }

      before { delete company_url(company_without_users) }

      it "destroys the requested company" do
        expect(Company).not_to exist(company_without_users.id)
      end

      it "redirects to the companies list" do
        expect(response).to redirect_to(companies_url)
      end
    end

    context "when the company has associated users" do
      before { delete company_url(company) }

      it "does not destroy the company" do
        expect(Company).to exist(company.id)
      end

      it "redirects to the companies list with an error message" do
        expect(response).to redirect_to(companies_url)
        follow_redirect!
        expect(response.body).to include("Cannot delete record because dependent users exist")
      end
    end
  end
end
