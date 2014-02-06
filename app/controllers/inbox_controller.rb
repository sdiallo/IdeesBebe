class InboxController < ApplicationController

  include Mandrill::Rails::WebHookProcessor

  def handle_inbound(event_payload)
    data = event_payload['msg']

    # email : 'receiver-username'.'product-id'@user.idees-bebe.com
    username, product_id = payload['headers']['To'].chomp('@user.dev-ideesbebe.com').split('.')

    content = EmailReplyParser.parse_reply(mail['text'])

    product = Product.find(product_id)
    sender = User.find_by_email(payload['from_email'])
    receiver = User.find_by_username(username)

    product.messages.create!(content: content, sender_id: sender.id, receiver_id: receiver_.d)
  end
end
