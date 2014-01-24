class InboxController < ApplicationController

  include Mandrill::Rails::WebHookProcessor

  def handle_inbound(event_payload)
    data = event_payload['msg']

    # email : 'receiver-username'.'product-id'@user.idees-bebe.com
    user, product = payload['headers']['To'].chomp('@user.dev-ideesbebe.com').split('.')

    message = Message.new
    message.content = EmailReplyParser.parse_reply(mail['text'])
    message.sender_id = User.find_by_slug(payload['from_email']).id
    message.receiver_id = User.find(user).id
    message.product_id = Product.find(product).id

    message.save!
  end
end
