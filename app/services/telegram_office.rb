require_relative '../../ema.rb'
require_relative 'telegram_gateway.rb'

class TelegramOffice


def initialize
  @gateway = TelegramGateway.new()
end

def send_message(username,to,signed_sender,signed_recipient)

    recipient = User.find_by(user_name:to)
    messages = [{username.to_str => signed_sender},{recipient._id.to_str => signed_to}]
    
    #TODO:check if Correspondence doesn't already exist
    newly_made =@gateway.new_message(messages)

    'Message has been sent!'

end


def conversations_with(current_id,receiver_id)

    response_sender_receiver = Correspondence.where(sender:current_id, reciever:receiver_id).to_json
    response_receiver_sender = Correspondence.where(sender:receiver_id, reciever:current_id).to_json
    conversation = response_sender_receiver + response_receiver_sender

    conversation

    current_key = sender.public_key

end


end