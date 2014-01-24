class InboxController < ApplicationController

  include Mandrill::Rails::WebHookProcessor

  def handle_inbound(event_payload)
    data = event_payload['msg']
    # self.content = EmailReplyParser.parse_reply(mail['text'])
    
  end
end
