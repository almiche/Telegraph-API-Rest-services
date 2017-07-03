require 'sinatra'
require_relative 'schema.rb'
require_relative 'telegraph.rb'

#Route used for sending telegrams
get '/send' do
    user = params['user']
    morse_message = params['message']
    mes = decode(morse_message)
    puts "#{mes}"
    new_message(user,decode(morse_message),morse_message)
   
end    

#Route to recieve telegrams
get '/conversation' do
    #We want to return the correspondance between these to users
    users = params['users'].split(":")

     "The follwoing users were in this Correspondance #{users}"

end


def new_message(user_name,decoded_message,coded_message)
Correspondance.create(

    user_name:user_name,
    date:DateTime.now,
    decodedmessage:decoded_message,
    codedmessage:coded_message
)

end