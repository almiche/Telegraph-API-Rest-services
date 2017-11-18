require_relative '../../app/models/schema.rb'
require_relative 'telegram_gateway.rb'
require_relative 'telegramMapper.rb'

class TelegramOffice


def initialize
  @gateway = TelegramGateway.new()
end

def send_message(session,params)

    user = params['user'] # seems redundant since user is already authenticated
    # if session[:username]
    # Temporary until session problem is fixed
    if session[:username]
        to = params['to']
        signed_sender = params['sender_coded']
        signed_to = params['to_coded']

        # sender User.find_by(user_name:session[:username])
        sender = User.find_by(user_name: user)
        recipient = User.find_by(user_name: to)

        # oids are inherently unique
        messages = [{ session[:username].to_str => signed_sender }, { recipient._id.to_str => signed_to }]

        puts messages.to_s

        # TODO: check if Correspondance doesn't already exist
        newly_made = new_message(messages)

        'Message has been sent!'

    else
        puts 'You are not authenticated to do this action'
    end
end


def conversations_with(session,params)

  #sender = User.find_by(user_name:session[:username])
  sender = User.find_by(session[:username])
  current_id = sender._id
  receiver = User.find_by(user_name:(params['receiver']))
  receiver_id = receiver._id

  response_sender_receiver = Correspondance.where(sender:current_id,reciever:reciever_id).to_json
  response_receiver_sender = Correspondance.where(sender:reciever_id,reciever:current_id).to_json
  conversation = response_sender_receiver + response_receiver_sender

  conversation

  # current_key = sender.public_key
end


end