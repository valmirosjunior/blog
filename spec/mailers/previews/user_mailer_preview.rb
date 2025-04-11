# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview the welcome email
  def welcome_email
    user = User.last

    UserMailer.welcome_email(user)
  end
end
