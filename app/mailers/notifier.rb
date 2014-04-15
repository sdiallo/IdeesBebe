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
      from: "Idees Bebe <#{@message.sender.slug}.#{@message.status.id}@user.dev-ideesbebe.com>",
      to: @message.receiver.email,
      subject: @subject
    )
  end

  def signalized_as_buyer(user, product)
    @user = user
    @product = product
    mail(
      from: 'Idees Bebe <#product.owner.slug}@user.dev-ideesbebe.com>',
      to: @user.email,
      subject: I18n.t('notifier.signalized_as_buyer.subject', product: @product.name)
    )
  end

  def reminder_owner(message, time)
    return false if not message.need_to_remember?
    @message = message
    @subject = I18n.t("notifier.reminder_owner_#{time}_days.subject")
    @user = message.sender
    mail(
      to: @message.receiver.email,
      subject: @subject
    )
  end
end
