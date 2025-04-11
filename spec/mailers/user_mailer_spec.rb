require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#welcome_email" do
    let(:company) { create(:company) }
    let(:user) { create(:user, company: company) }
    let(:mail) { UserMailer.welcome_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to Our Platform")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ENV["SMTP_USERNAME"]])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Welcome, #{user.display_name}!")
      expect(mail.body.encoded).to include("You have been added to the company <strong>#{company.name}</strong>")
      expect(mail.body.encoded).to include("#{ENV["HOST_URL"]}/")
    end
  end
end
