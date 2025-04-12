require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:users).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'dependent destroy behavior' do
    let!(:company) { create(:company) }
    let!(:user) { create(:user, company: company) }

    context 'when the company has associated users' do
      it 'does not allow the company to be destroyed' do
        expect { company.destroy }.not_to change(described_class, :count)

        expect(company.errors[:base]).to include("Cannot delete record because dependent users exist")
      end
    end

    context 'when the company has no associated users' do
      before { user.destroy }

      it 'allows the company to be destroyed' do
        expect { company.destroy }.to change(described_class, :count).by(-1)
      end
    end
  end
end
