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
    @product = message.product
    @receiver = message.from_seller? ? message.conversation.buyer.email : message.product.user.email
    @subject = message.from_seller? ? I18n.t('notifier.new_message.from_seller.subject') : I18n.t('notifier.new_message.from_buyer.subject')
    mail(
      from: "Idees Bebe <#{@message.sender.slug}.#{@message.conversation.id}@user.dev-ideesbebe.com>",
      to: @receiver,
      subject: @subject
    )
  end
end
