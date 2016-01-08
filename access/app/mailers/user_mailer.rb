class UserMailer < ApplicationMailer
  default from: APP_CONFIG['email']['default_from']

  def new_user_registration_confirmation(user)
    @user = user
    mail(to: @user.email,
         subject: "#{I18n.t "mailers.user_mailer.confirmation_mail_subject"} #{@user.first_name} #{@user.last_name}")
  end

  def new_alt_mail_confirmation(alt_mail)
    @alt_mail = AlternativeEmail.find_by_email alt_mail
    @user = @alt_mail.person
    mail(to: alt_mail,
         subject: "#{I18n.t "mailers.user_mailer.email_confirmation_subject"} #{@user.first_name} #{@user.last_name}")
  end
end
