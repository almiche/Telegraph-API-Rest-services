require 'sinatra'
require 'bundler'
require_relative('../app/services/telegramMapper')
require_relative('../app/services/registrar_mapper')

class MyApp < Sinatra::Application
  use Rack::Session::Cookie, key: 'rack.session',
                             path: '/',
                             secret: 'your_secret'

  # secret should be randomized TODO

  def initialize(app = nil)
    super(app)
    @telegram_mapper = TelegramMapper.new
    @registrar_mapper = RegistrarMapper.new
  end

  get '/currentuser' do
    @telegram_mapper.current_user(session)
  end

  # Route used for sending telegrams
  get '/send' do
    @telegram_mapper.send_message(session, params)
  end

  # Route to recieve telegrams
  get '/conversations' do
    @telegram_mapper.conversations_with(session, params)
  end

  # route to signup
  post '/signup' do
    @registrar_mapper.create_new_user(session, params)
  end

  # route to login
  post '/login' do
    if @registrar_mapper.authenticate(session, params)
      session[:username] = params[:username]
      200
    else
      'User does not exist !'
      404
    end
  end

  get '/logout' do
    session[:username] = nil
    'You have been logged out'
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
        ws.send(msg.data)
      end

      ws.on(:close) do |_event|
        puts 'On Close'
      end

      ws.rack_response
    else
      erb :index
    end
  end

  # return public key of any user
  get '/publickey' do
    user = params['user']
    key = User.find_by(user_name: user).public_key
    key
  end

  MyApp.run!
end
