require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'scopes' do
    let!(:user_1) { create(:user) }
    let!(:user_2) { create(:user) }
    let!(:tweet_1) { create(:tweet, user: user_1, created_at: 2.days.ago) }
    let!(:tweet_2) { create(:tweet, user: user_1, created_at: 1.day.ago) }
    let!(:tweet_3) { create(:tweet, user: user_2, created_at: Time.current) }

    describe '.newest_first' do
      it 'returns tweets ordered by most recent first' do
        expect(Tweet.newest_first).to eq([tweet_3, tweet_2, tweet_1])
      end
    end

    describe '.by_username' do
      it 'returns tweets for the specified username' do
        expect(Tweet.by_username(user_1.username)).to match_array([tweet_1, tweet_2])
        expect(Tweet.by_username(user_2.username)).to match_array([tweet_3])
      end

      it 'returns an empty array if no tweets match the username' do
        expect(Tweet.by_username('nonexistent_user')).to be_empty
      end

      it 'returns all tweets if no username is provided' do
        expect(Tweet.by_username(nil)).to match_array([tweet_1, tweet_2, tweet_3])
      end
    end
  end
end
