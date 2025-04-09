class TweetsController < ApplicationController
  def index
    render json: paginate(Tweet.newest_first)
  end
end
