require 'sinatra'
require_relative 'schema.rb'
require_relative 'telegraph.rb'
require 'net/http'
require 'bcrypt'
require 'pry'




class MyApp < Sinatra::Application

use Rack::Session::Cookie, :key => 'rack.session',
:path => '/',
:secret => 'your_secret'

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

#route to signup
post "/signup" do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  user = params[:username]
  keybase_user=params[:keybase]
  begin 
    User.find_by(user_name: params[:username])
    "User already exists!"
  rescue  
  new_user(user,keybase_user,password_hash,password_salt)
  session[:username] = params[:username]

  puts "Current username is #{session[:username] }"

  end
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
      puts "Succesful login! #{session[:username]}"
      "Succesful login! #{session[:username]}"
    end

    end
end

get "/logout" do
    #binding.pry
  session[:username] = nil
  "You have been logged out"
end

get "/currentuser" do
    "Current user is #{session[:username]}"
end

#Route used for sending telegrams
get '/send' do
    user = params['user'] #seems redundant since user is already authenticated
    userr = session[:username]
    puts "#{userr}" 
    #if session[:username] 
    #Temporary until session problem is fixed
    if true
    to = params['to']
    signed_sender = params['sender_coded']
    signed_to = params['to_coded']

    sender = User.find_by(user_name:session[:username])
    recipient = User.find_by(user_name:to)
    
    #oids are inherently unique
    messages = [{sender._id.to_str => signed_sender},{recipient._id.to_str => signed_to}]
    
    puts "#{messages}"

    #TODO:check if Correspondance doesn't already exist
    newly_made =new_message(messages)
    
    "Message has been sent!"

    else
        puts "You are not authenticated to do this action"
    end
    
end    

#Route to recieve telegrams
get '/conversations' do
    #sender = User.find_by(user_name:session[:username])
    sender = User.find_by(user_name:params['username'])
    current_id = sender._id
    reciever = User.find_by(user_name:(params['reciever']))
    reciever_id = reciever._id

    response_sender_reciever = Correspondance.where(sender:current_id,reciever:reciever_id).to_json
    response_reciever_sender = Correspondance.where(sender:reciever_id,reciever:current_id).to_json
    convo = response_sender_reciever + response_reciever_sender
    
    convo
    
    # current_key = sender.public_key
end

#return public key of any user
get '/publickey' do
    user = params['user']
    key = User.find_by(user_name:user).public_key
    key
end

def new_user(user_name,keybase_username,password_hash,password_salt)
    #Fetch the user's public key from keybase.io
    url = "https://keybase.io/_/api/1.0/user/lookup.json?usernames=#{keybase_username}" 
    result = JSON.parse(Net::HTTP.get(URI.parse(url)))
    username_from_keybase = p result["them"][0]["basics"]["username"]
    public_key = result["them"][0]["public_keys"]["primary"]["bundle"]

    puts "#{public_key}"

    noob = User.create(
        user_name:user_name,
        public_key:public_key,
        password_hash:password_hash,
        password_salt:password_salt
    )

    noob
end

def new_message(messages)
Correspondance.create(
    sender:messages[0].keys.join,
    reciever:messages[1].keys.join,
    messages:messages,
    date:Time.now.iso8601,
)

end

end

MyApp.run!