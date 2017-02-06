class NotificationMailer < ApplicationMailer
  def new_user(user)
    @user = user
    mail(to: Rails.application.config.support_email, subject: 'Nouvel utilisateur ApiApp')
  end
end
