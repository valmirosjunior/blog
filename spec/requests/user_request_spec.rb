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
end
