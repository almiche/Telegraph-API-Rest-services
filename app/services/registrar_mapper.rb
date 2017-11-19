require_relative('../../app/services/telegram_gateway')
require 'net/http'
require 'bcrypt'
require_relative('../../app/models/schema.rb')


class RegistrarMapper

  def initialize
    @gateway = TelegramGateway.new()
  end

  def create_new_user(session,params)
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
    user_name = params[:username]
    keybase_username = params[:keybase]

    begin
      user = @gateway.find_by_username(params[:username])
      puts "#{user}"
      'User already exists!'
    rescue
      session[:username] = params[:username]
      @gateway.new_user(user_name, keybase_username, password_hash, password_salt)
    end
  end

  def authenticate(session,params)
    puts "#{params[:username]}"
    user = @gateway.find_by_username(params[:username])
    password_hash = user.password_hash
    password_salt = user.password_salt
    return true if password_hash == BCrypt::Engine.hash_secret(params[:password], password_salt)
  end
  end


