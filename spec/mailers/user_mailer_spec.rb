require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  describe 'account_activation' do
    let(:mail) { UserMailer.account_activation(user).deliver_now }

    before do
      user.activation_token = User.new_token
    end

    it 'sends with the title of Acount Activation' do
      expect(mail.subject).to eq('Acount Activation')
    end

    it 'sends to an email of users' do
      expect(mail.to).to eq([user.email])
    end

    it 'sends from noreply@example.com' do
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'displays the username in the body of the email' do
      expect(mail.body.encoded).to match(user.name)
    end

    it 'displays the activation_token in the body of the email' do
      expect(mail.body.encoded).to match(user.activation_token)
    end

    it 'displays the email of users in the body of the email' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset(user) }

    before do
      user.reset_token = User.new_token
    end

    it 'sends with the title of Password Reset' do
      expect(mail.subject).to eq('Password Reset')
    end

    it 'sends to an email of users' do
      expect(mail.to).to eq([user.email])
    end

    it 'sends from noreply@example.com' do
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'displays the reset token in the body of the email' do
      expect(mail.body.encoded).to match(user.reset_token)
    end

    it 'displays the email of users in the body of the email' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end