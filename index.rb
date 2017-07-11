require 'sinatra'
require_relative 'schema.rb'
require_relative 'telegraph.rb'
require 'net/http'
require 'bcrypt'

enable :sessions

helpers do
  
  def login?
    if session[:username].nil?
      return false
    else
      return true
    end
  end
  
  def username
    return session[:username]
  end
  
end

#route to login
post "/signup" do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  user = params['user']
  keybase_user=params['keybase']
  new_user(user,keybase_user,password_hash,password_salt)
  
  session[:username] = params[:username]
  word = session[:username]

  puts "Current username is #{session}"
end

#route to login
post "/login" do
    user = User.find_by(user_name: params[:username])
    if user
        user_name=  user.user_name
        password_hash = user.password_hash
        password_salt = user.password_salt
    if password_hash== BCrypt::Engine.hash_secret(params[:password], password_salt)
      session[:username] = params[:username]
      puts "Succesful login!"
    end

    end
end

get "/logout" do
  session[:username] = nil
  redirect "/"
end

#Route used for sending telegrams
get '/send' do
    user = params['user']
    if session
    morse_message = params['message']
    mes = decode(morse_message)
    reciever = params['to']
    puts "#{mes}"
    new_message(user,reciever,decode(morse_message),morse_message)
    else
        puts "You are not authenticated to do this action"
    end
    
end    

#Route to recieve telegrams
get '/conversation' do
    #We want to return the correspondance between these to users
    current_user=params['user']
    Correspondance.collection.find({ user_name: current_user }).select.to_json

end

def new_user(user_name,keybase_username,password_hash,password_salt)
    #Fetch the user's public key from keybase.io
    url = "https://keybase.io/_/api/1.0/user/lookup.json?usernames=#{keybase_username}" 
    result = JSON.parse(Net::HTTP.get(URI.parse(url)))
    username_from_keybase = p result["them"][0]["basics"]["username"]
    public_key = result["them"][0]["public_keys"]["primary"]["bundle"]

    puts "#{public_key}"

    User.create(
        user_name:user_name,
        public_key:public_key,
        conversation_ids:[],
        password_hash:password_hash,
        password_salt:password_salt
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