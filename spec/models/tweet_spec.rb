require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'scopes' do
    let!(:tweet_1) { create(:tweet, created_at: 2.days.ago) }
    let!(:tweet_2) { create(:tweet, created_at: 1.day.ago) }
    let!(:tweet_3) { create(:tweet, created_at: Time.current) }

    describe '.newest_first' do
      it 'returns tweets ordered by most recent first' do
        expect(Tweet.newest_first).to eq([tweet_3, tweet_2, tweet_1])
      end
    end
  end
end
