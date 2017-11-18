require 'sinatra'
require_relative '../app/models/schema.rb'
require 'net/http'
require 'bcrypt'
require 'pry'
require 'bundler'
require_relative('../app/services/telegramMapper')
require_relative('../app/services/registrar_mapper')

class MyApp < Sinatra::Application
  use Rack::Session::Cookie, key: 'rack.session',
                             path: '/',
                             secret: 'your_secret'

  helpers do
    def login?
      if session[:username].nil?
        false
      else
        true
      end
    end

    def username
      session[:username]
    end
  end

  def initialize(app = nil)
    super(app)
    @telegram_mapper = TelegramMapper.new
    @registrar_mapper = RegistrarMapper.new()

  end

  Bundler.require
  Faye::WebSocket.load_adapter('thin')

  get '/messaging' do
    if Faye::WebSocket.websocket?(request.env)
      ws = Faye::WebSocket.new(request.env)

      ws.on(:open) do |_event|
        puts 'On Open'
        ws.send(session[:user])
      end

      ws.on(:message) do |msg|
        puts 'Gottem'
        ws.send(msg.data) # Reverse and reply
      end

      ws.on(:close) do |_event|
        puts 'On Close'
      end

      ws.rack_response
    else
      erb :index
    end
  end



  get '/currentuser' do
    "Current user is #{session[:username]}"
  end

  # Route used for sending telegrams
  get '/send' do
    @telegram_mapper.send_message(session, params)
  end

  # Route to recieve telegrams
  get '/conversations' do
    @telegram_mapper.view_conversations(session, params)
  end

  # return public key of any user
  get '/publickey' do
    user = params['user']
    key = User.find_by(user_name: user).public_key
    key
  end


  # route to signup
  post '/signup' do
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
    user = params[:username]
    keybase_user = params[:keybase]
    begin
      User.find_by(user_name: params[:username])
      'User already exists!'
    rescue
      @registrar_mapper.create_new_user(user, keybase_user, password_hash, password_salt)
      session[:username] = params[:username]

      puts "Current username is #{session[:username]}"
    end
  end

  # route to login
  post '/login' do
    user = User.find_by(user_name: params[:username])
    if user
      user_name = user.user_name
      password_hash = user.password_hash
      password_salt = user.password_salt
      if password_hash == BCrypt::Engine.hash_secret(params[:password], password_salt)
        session[:username] = params[:username]
        puts "Succesful login! #{session[:username]}"
        "Succesful login! #{session[:username]}"
      end

    end
  end

  get '/logout' do
    # binding.pry
    session[:username] = nil
    'You have been logged out'
  end



MyApp.run!

end