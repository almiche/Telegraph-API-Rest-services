require_relative('../../app/services/telegram_gateway')

class RegistrarMapper

  def initialize
    @gateway = TelegramGateway.new()
  end

  def create_new_user(user, keybase_user, password_hash, password_salt)
    @gateway.new_user(user, keybase_user, password_hash, password_salt)
  end



end