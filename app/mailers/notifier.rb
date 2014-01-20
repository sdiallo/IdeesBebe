class Notifier < ActionMailer::Base
  default from: 'support@idees-bebe.com'

  def welcome user
    @user = user
    @subject = I18n.t('notifier.welcome.subject')
    mail(
      to: @user.email,
      subject: @subject
    )
  end
end
