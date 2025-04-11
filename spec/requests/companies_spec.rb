require 'rails_helper'

RSpec.describe "/companies", type: :request do
  let(:valid_attributes) {
    { name: "Test Company" }
  }

  let(:invalid_attributes) {
    { name: "" } # Invalid because the name is blank
  }

  describe "GET /index" do
    it "renders a successful response" do
      Company.create! valid_attributes
      get companies_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      company = Company.create! valid_attributes
      get company_url(company)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_company_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      company = Company.create! valid_attributes
      get edit_company_url(company)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Company" do
        expect {
          post companies_url, params: { company: valid_attributes }
        }.to change(Company, :count).by(1)
      end

      it "redirects to the created company" do
        post companies_url, params: { company: valid_attributes }
        expect(response).to redirect_to(company_url(Company.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Company" do
        expect {
          post companies_url, params: { company: invalid_attributes }
        }.not_to change(Company, :count)
      end

      it "renders a response with status 422 (unprocessable entity)" do
        post companies_url, params: { company: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) {
      { name: "Updated Company Name" }
    }

    context "with valid parameters" do
      it "updates the requested company" do
        company = Company.create! valid_attributes
        patch company_url(company), params: { company: new_attributes }
        company.reload
        expect(company.name).to eq("Updated Company Name")
      end

      it "redirects to the company" do
        company = Company.create! valid_attributes
        patch company_url(company), params: { company: new_attributes }
        expect(response).to redirect_to(company_url(company))
      end
    end

    context "with invalid parameters" do
      it "does not update the company" do
        company = Company.create! valid_attributes
        patch company_url(company), params: { company: invalid_attributes }
        company.reload
        expect(company.name).to eq("Test Company") # Name should remain unchanged
      end

      it "renders a response with status 422 (unprocessable entity)" do
        company = Company.create! valid_attributes
        patch company_url(company), params: { company: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when the company has no associated users" do
      it "destroys the requested company" do
        company = Company.create! valid_attributes
        expect {
          delete company_url(company)
        }.to change(Company, :count).by(-1)
      end

      it "redirects to the companies list" do
        company = Company.create! valid_attributes
        delete company_url(company)
        expect(response).to redirect_to(companies_url)
      end
    end

    context "when the company has associated users" do
      it "does not destroy the company and shows an error message" do
        company = Company.create! valid_attributes
        create(:user, company: company)

        expect {
          delete company_url(company)
        }.not_to change(Company, :count)

        expect(response).to redirect_to(companies_url)
        follow_redirect!
        expect(response.body).to include("Cannot delete record because dependent users exist")
      end
    end
  end
end
