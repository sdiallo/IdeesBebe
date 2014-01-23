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

  def new_message message
    @receiver = message.product.user
    @sender = message.user
    @subject = I18n.t('notifier.new_message.subject')
    mail(
      from: "Idees Bebe <#{@sender.slug}@idees-bebe.com>",
      to: @receiver.email,
      subject: @subject
    )
  end
end
