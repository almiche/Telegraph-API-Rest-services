require 'sinatra'
require_relative 'schema.rb'
require_relative 'telegraph.rb'
require 'net/http'

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

get '/newuser' do 
    user = params['user']
    keybase_user=params['keybase']
    password = params['user']
    new_user(user,keybase_user,password)

end

def new_user(user_name,keybase_username,password)
    url = "https://keybase.io/_/api/1.0/user/lookup.json?usernames=#{keybase_username}" 
    result = JSON.parse(Net::HTTP.get(URI.parse(url)))
    username_from_keybase = p result["them"][0]["basics"]["username"]
    public_key = result["them"][0]["public_keys"]["primary"]["bundle"]

    puts "#{public_key}"

    User.create(
        user_name:user_name,
        public_key:public_key,
        conversation_ids:[0,0,3,2],
        password:password
    )
end

def new_message(user_name,to,decoded_message,coded_message)
Correspondance.create(

    user_name:user_name,
    to:to,
    date:Time.now.utc,
    decodedmessage:decoded_message,
    codedmessage:coded_message
)

end