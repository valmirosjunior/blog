class UsersController < ApplicationController
  before_action :set_company, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    users = User
              .by_company(params[:company_id])
              .by_username(search_params[:username])

    render json: users.all
  end

  def new
    @user = @company.users.build
  end

  def edit; end

  def create
    @user = @company.users.build(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver_now

      redirect_to company_path(@company), notice: 'User was successfully created, and an email has been sent.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to company_path(@company), notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to company_path(@company), notice: 'User was successfully deleted.'
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

  def set_user
    @user = @company.users.find(params[:id])
  end
end
