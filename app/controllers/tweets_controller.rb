class TweetsController < ApplicationController
  def index
    tweets = Tweet
               .by_username(params[:user_username])
               .newest_first

    render json: paginate(tweets)
  end
end
