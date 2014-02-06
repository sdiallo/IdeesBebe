class InboxController < ApplicationController

  include Mandrill::Rails::WebHookProcessor

  def handle_inbound(event_payload)
    data = event_payload['msg']

    slug, product_id = data['headers']['To'].split('@')[0]
    content = EmailReplyParser.parse_reply(data['text'])
    raise "#{slug} , #{product_id}".inspect
    product = Product.find(product_id)
    sender = User.find_by_email(data['from_email'])
    receiver = User.find_by_slug(slug)

    product.messages.create!(content: content, sender_id: sender.id, receiver_id: receiver.id)
  end
end
