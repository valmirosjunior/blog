require 'rails_helper'

RSpec.describe "Tweets", type: :request do
  describe "GET /tweets" do
    let(:total_tweets) { max_limit + exced_limit_records }
    let(:max_limit) { 100 }
    let(:exced_limit_records) { 5 }
    let(:per_page) { 10 }
    let(:last_page) { (total_tweets / per_page.to_f).ceil }
    let(:sorted_tweets) { Tweet.newest_first }

    let(:user) { create(:user) }
    let!(:tweets_user) { create_list(:tweet, exced_limit_records , user: user) }

    before do
      create_list(:tweet, max_limit)

      get tweets_path, params: params
    end

    context "when no pagination params are provided" do
      let(:params) { {} }
      let(:first_tweet_of_page) { sorted_tweets.first }
      let(:last_tweet_of_page) { sorted_tweets[per_page - 1] }
      let(:current_page) { 1 }
      let(:next_page) { 2 }

      it "returns the first page of tweets with default per_page" do
        expect(response).to have_http_status(:ok)
        expect(json_response["tweets"].size).to eq(per_page)
        expect(json_response["tweets"].first["id"]).to eq(first_tweet_of_page.id)
        expect(json_response["tweets"].last["id"]).to eq(last_tweet_of_page.id)
        expect(json_response["meta"]["current_page"]).to eq(current_page)
        expect(json_response["meta"]["per_page"]).to eq(per_page)
        expect(json_response["meta"]["next_page"]).to eq(next_page)
        expect(json_response["meta"]["prev_page"]).to be_nil
      end
    end

    context "when pagination params are provided" do
      let(:page) { 2 }
      let(:custom_per_page) { 5 }
      let(:params) { { page: page, per_page: custom_per_page } }
      let(:first_tweet_of_page) { sorted_tweets[(page - 1) * custom_per_page] }
      let(:last_tweet_of_page) { sorted_tweets[(page * custom_per_page) - 1] }
      let(:next_page) { 3 }
      let(:prev_page) { 1 }

      it "returns the correct page of tweets" do
        expect(response).to have_http_status(:ok)
        expect(json_response["tweets"].size).to eq(custom_per_page)
        expect(json_response["tweets"].first["id"]).to eq(first_tweet_of_page.id)
        expect(json_response["tweets"].last["id"]).to eq(last_tweet_of_page.id)
        expect(json_response["meta"]["current_page"]).to eq(page)
        expect(json_response["meta"]["per_page"]).to eq(custom_per_page)
        expect(json_response["meta"]["next_page"]).to eq(next_page)
        expect(json_response["meta"]["prev_page"]).to eq(prev_page)
      end
    end

    context "when requesting the last page" do
      let(:page) { last_page }
      let(:params) { { page: page, per_page: per_page } }
      let(:remaining_tweets_count) { total_tweets % per_page }
      let(:first_tweet_of_page) { sorted_tweets[(page - 1) * per_page] }
      let(:last_tweet_of_page) { sorted_tweets.last }
      let(:prev_page) { page - 1 }

      it "returns the remaining tweets and no next page" do
        expect(response).to have_http_status(:ok)
        expect(json_response["tweets"].size).to eq(remaining_tweets_count)
        expect(json_response["tweets"].first["id"]).to eq(first_tweet_of_page.id)
        expect(json_response["tweets"].last["id"]).to eq(last_tweet_of_page.id)
        expect(json_response["meta"]["current_page"]).to eq(page)
        expect(json_response["meta"]["per_page"]).to eq(per_page)
        expect(json_response["meta"]["next_page"]).to be_nil
        expect(json_response["meta"]["prev_page"]).to eq(prev_page)
      end
    end

    context "when per_page exceeds the maximum limit" do
      let(:params) { { page: page, per_page: total_tweets } }
      let(:page) { 1 }

      it "limits the per_page to MAX_LIMIT" do
        expect(response).to have_http_status(:ok)
        expect(json_response["tweets"].size).to eq(max_limit)
        expect(json_response["meta"]["per_page"]).to eq(max_limit)
        expect(json_response["meta"]["next_page"]).to eq(page + 1)
        expect(json_response["meta"]["prev_page"]).to be_nil
      end
    end

    context "when no tweets exist" do
      let(:params) { {} }
      let(:current_page) { 1 }

      before do
        Tweet.delete_all

        get tweets_path, params: params
      end

      it "returns an empty array and no next page" do
        expect(response).to have_http_status(:ok)
        expect(json_response["tweets"]).to eq([])
        expect(json_response["meta"]["current_page"]).to eq(current_page)
        expect(json_response["meta"]["per_page"]).to eq(per_page)
        expect(json_response["meta"]["next_page"]).to be_nil
        expect(json_response["meta"]["prev_page"]).to be_nil
      end
    end

    context "when filtering tweets by username" do
      context "when username matches a user" do
        let(:params) { { user_username: user.username } }

        it "returns tweets belonging to the specified user" do
          expect(response).to have_http_status(:ok)
          expect(json_response["tweets"].size).to eq(exced_limit_records)
          expect(json_response["tweets"].map { |tweet| tweet["id"] }).to match_array(tweets_user.map(&:id))
          expect(json_response["meta"]["per_page"]).to eq(per_page)
          expect(json_response["meta"]["next_page"]).to be_nil
          expect(json_response["meta"]["prev_page"]).to be_nil
        end
      end

      context "when username does not match any user" do
        let(:params) { { user_username: 'nonexistent_user' } }

        it "returns an empty array" do
          expect(response).to have_http_status(:ok)
          expect(json_response["tweets"]).to eq([])
          expect(json_response["meta"]["per_page"]).to eq(per_page)
          expect(json_response["meta"]["next_page"]).to be_nil
          expect(json_response["meta"]["prev_page"]).to be_nil
        end
      end
    end
  end
end
