class UsersController < ApplicationController
  before_action :set_company, only: [:new, :create]

  def index
    users = User
              .by_company(params[:company_id])
              .by_username(search_params[:username])

    render json: users.all
  end

  def new
    @user = @company.users.build
  end

  def create
    @user = @company.users.build(user_params)

    if @user.save
      redirect_to company_path(@company), notice: 'User was successfully created.'
    else
      render :new
    end
  end

  private

  def search_params
    params.permit(:username)
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  def user_params
    params.require(:user).permit(:display_name, :email, :username)
  end
end
