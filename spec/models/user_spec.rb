require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:company) }
  end

  describe 'validations' do
    it { should validate_presence_of(:display_name) }
    it { should validate_length_of(:display_name).is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    it { should validate_presence_of(:username) }
    it { should validate_length_of(:username).is_at_least(3).is_at_most(20) }
    it { should validate_uniqueness_of(:username).case_insensitive }
  end

  describe 'scopes' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }
    let!(:user_1) { create(:user, company: company_1, username: 'john_doe') }
    let!(:user_2) { create(:user, company: company_1, username: 'jane_doe') }
    let!(:user_3) { create(:user, company: company_2, username: 'john_smith') }

    describe '.by_company' do
      it 'returns users belonging to the specified company' do
        expect(User.by_company(company_1.id)).to match_array([user_1, user_2])
        expect(User.by_company(company_2.id)).to match_array([user_3])
      end

      it 'returns all users if no company_id is provided' do
        expect(User.by_company(nil)).to match_array([user_1, user_2, user_3])
      end
    end

    describe '.by_username' do
      it 'returns users matching the username' do
        expect(User.by_username('john')).to match_array([user_1, user_3])
        expect(User.by_username('jane')).to match_array([user_2])
      end

      it 'returns all users if no username is provided' do
        expect(User.by_username(nil)).to match_array([user_1, user_2, user_3])
      end
    end
  end
end
