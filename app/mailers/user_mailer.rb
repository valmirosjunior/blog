class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @company = user.company
    @url = "#{ENV['HOST_URL']}/"

    mail(to: @user.email, subject: 'Welcome to Our Platform')
  end
end
