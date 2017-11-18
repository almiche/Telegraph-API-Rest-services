require('sinatra')
require_relative('../../app/models/schema')
require_relative('telegram_office')

class TelegramMapper

  def initialize
    @office = TelegramOffice.new()
  end

  def conversations_with(session,params)
    @office.conversations_with(session,params)

  end

  def send_message(session,params)
    @office.send_message(session,params)
  end

end
