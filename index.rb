require 'sinatra'
require_relative 'schema.rb'
require_relative 'telegraph.rb'

#Route used for sending telegrams
get '/send' do
    user = params['user']
    morse_message = params['message']
    mes = decode(morse_message)
    reciever = params['to']
    puts "#{mes}"
    new_message(user,reciever,decode(morse_message),morse_message)
   
end    

#Route to recieve telegrams
get '/conversation' do
    #We want to return the correspondance between these to users
    current_user=params['user']
    Correspondance.collection.find({ user_name: current_user }).select.to_json

end


def new_message(user_name,to,decoded_message,coded_message)
Correspondance.create(

    user_name:user_name,
    to:to,
    date:DateTime.now,
    decodedmessage:decoded_message,
    codedmessage:coded_message
)

end