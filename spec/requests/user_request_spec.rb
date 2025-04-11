require 'rails_helper'

RSpec.describe "Users", type: :request do

  RSpec.shared_context 'with multiple companies' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times do |i|
        create(:user, company: company_1, username: "user_#{i}_company_1")
      end
      5.times do |i|
        create(:user, company: company_2, username: "user_#{i}_company_2")
      end
    end
  end

  describe "#index" do
    context 'when fetching users by company' do
      include_context 'with multiple companies'

      it 'returns only the users for the specified company' do
        get company_users_path(company_1)
        
        expect(json_response.size).to eq(company_1.users.size)
        expect(json_response.map { |element| element['id'] }).to eq(company_1.users.ids)
      end
    end

    context 'when fetching all users' do
      include_context 'with multiple companies'

      it 'returns all the users' do
        get users_path
        
        total_users = company_1.users.size + company_2.users.size

        expect(json_response.size).to eq(total_users)
        expect(json_response.map { |element| element['id'] }).to match_array(User.ids)
      end
    end

    context 'when searching users by username' do
      include_context 'with multiple companies'

      it 'returns users matching the username' do
        get users_path, params: { username: 'user_1' }

        matching_users = User.where("username LIKE ?", "%user_1%")

        expect(json_response.size).to eq(matching_users.size)
        expect(json_response.map { |element| element['id'] }).to match_array(matching_users.ids)
      end

      it 'returns no users if no username matches' do
        get users_path, params: { username: 'nonexistent_user' }

        expect(json_response.size).to eq(0)
      end
    end
  end

  describe "#new" do
    let!(:company) { create(:company) }

    it 'renders the new user form' do
      get new_company_user_path(company)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('form')
    end
  end

  describe "#create" do
    let!(:company) { create(:company) }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            display_name: 'John Doe',
            email: 'john.doe@example.com',
            username: 'johndoe'
          }
        }
      end

      it 'creates a new user and sends a welcome email' do
        expect {
          post company_users_path(company), params: valid_params
        }.to change(User, :count).by(1)

        expect(ActionMailer::Base.deliveries.last.to).to include('john.doe@example.com')

        expect(response).to redirect_to(company_path(company))

        follow_redirect!
        expect(response.body).to include('User was successfully created, and an email has been sent.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            display_name: '',
            email: 'invalid_email',
            username: ''
          }
        }
      end

      it 'does not create a new user and re-renders the form' do
        expect {
          post company_users_path(company), params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('form')
      end
    end
  end
end
