class InboxController < ApplicationController

  include Mandrill::Rails::WebHookProcessor

  def handle_inbound(event_payload)
    data = event_payload['msg']

    # email : 'receiver-username'.'product-id'@user.idees-bebe.com
    user, conversation = payload['headers']['To'].chomp('@user.dev-ideesbebe.com').split('.')
    content = EmailReplyParser.parse_reply(mail['text'])
    sender = User.find_by_email(payload['from_email'])

    conversation = Conversation.find(conversation)
    conversation.messages.create!(content: content, sender_id: sender.id)
  end
end
