require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:tweets).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:display_name) }
    it { is_expected.to validate_length_of(:display_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid_email').for(:email) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(20) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
  end

  describe 'scopes' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }
    let!(:user_1) { create(:user, company: company_1, username: 'john_doe') }
    let!(:user_2) { create(:user, company: company_1, username: 'jane_doe') }
    let!(:user_3) { create(:user, company: company_2, username: 'john_smith') }

    describe '.by_company' do
      it 'returns users belonging to the specified company' do
        expect(described_class.by_company(company_1.id)).to contain_exactly(user_1, user_2)
        expect(described_class.by_company(company_2.id)).to contain_exactly(user_3)
      end

      it 'returns all users if no company_id is provided' do
        expect(described_class.by_company(nil)).to contain_exactly(user_1, user_2, user_3)
      end
    end

    describe '.by_username' do
      it 'returns users matching the username' do
        expect(described_class.by_username('john')).to contain_exactly(user_1, user_3)
        expect(described_class.by_username('jane')).to contain_exactly(user_2)
      end

      it 'returns all users if no username is provided' do
        expect(described_class.by_username(nil)).to contain_exactly(user_1, user_2, user_3)
      end
    end
  end
end
