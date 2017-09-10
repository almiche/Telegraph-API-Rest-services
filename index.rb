require 'sinatra'
require_relative 'schema.rb'
require_relative 'telegraph.rb'
require 'net/http'
require 'bcrypt'
require 'pry'

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

#route to signup
post "/signup" do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  user = params[:username]
  keybase_user=params[:keybase]
  new_user(user,keybase_user,password_hash,password_salt)
  
  session[:username] = params[:username]
  $current_user = session[:username]

  puts "Current username is #{$current_user}"
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
      $current_user = session[:username]
      puts "Succesful login! #{$current_user}"
      "Succesful login! #{$current_user}"
    end

    end
end

get "/logout" do
    binding.pry
  session[:username] = nil
  redirect "/"
end

#Route used for sending telegrams
get '/send' do
    user = params['user'] #seems redundant since user is already authenticated
    if $current_user 
    to = params['to']
    signed_sender = params['sender_coded']
    signed_to = params['to_coded']

    sender = User.find_by(user_name:$current_user)
    recipient = User.find_by(user_name:to)
    
    #oids are inherently unique
    participants = [{sender._id.to_str => signed_sender},{recipient._id.to_str => signed_to}]
    
    puts "#{participants}"

    #TODO:check if Correspondance doesn't already exist
    newly_made =new_message(participants)
    else
        puts "You are not authenticated to do this action"
    end
    
end    

#Route to recieve telegrams
get '/conversation' do
    sender = User.find_by(user_name:$current_user)
    recipient = User.find_by(user_name:to)

    current = sender._id
    other =receipient._id

    current_key = sender.public_key

    Correspondance.find_by()

    


    #We want to return the correspondance between these to users
    convos = Correspondance.collection.find({ user_name: $current_user }).select.to_json
    convos
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

def new_message(participants)
Correspondance.create(

    participants:participants,
    date:Time.now.iso8601,
)

end
