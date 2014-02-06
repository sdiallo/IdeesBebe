class Notifier < ActionMailer::Base
  default from: 'Idees Bebe <support@dev-ideesbebe.com>'

  def welcome user
    @user = user
    @subject = I18n.t('notifier.welcome.subject')
    mail(
      to: @user.email,
      subject: @subject
    )
  end

  def new_message message
    @message = message
    @subject = message.from_owner? ? I18n.t('notifier.new_message.from_owner.subject') : I18n.t('notifier.new_message.from_buyer.subject')
    @user = message.from_owner? ? message.receiver : message.sender
    mail(
      from: "Idees Bebe <#{@message.sender.slug}.#{@message.product.id}@user.dev-ideesbebe.com>",
      to: @message.receiver.email,
      subject: @subject
    )
  end
end
