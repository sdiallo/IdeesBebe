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
    @receiver = message.receiver
    @sender = message.sender
    @product = message.product
    @subject = message.seller_message? ? I18n.t('notifier.new_message.from_seller.subject') : I18n.t('notifier.new_message.from_buyer.subject')
    mail(
      from: "Idees Bebe <#{@sender.slug}.#{@product.id}@user.dev-idees-bebe.com>",
      to: @receiver.email,
      subject: @subject
    )
  end
end
