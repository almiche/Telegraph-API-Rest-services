require_relative('../../app/models/schema')

class TelegramGateway
  def new_user(user_name, keybase_username, password_hash, password_salt)

    # Fetch the user's public key from keybase.io
    url = "https://keybase.io/_/api/1.0/user/lookup.json?usernames=#{keybase_username}"
    result = JSON.parse(Net::HTTP.get(URI.parse(url)))
    public_key = result['them'][0]['public_keys']['primary']['bundle']

    new_user = User.create(
      user_name: user_name,
      public_key: public_key,
      password_hash: password_hash,
      password_salt: password_salt
    )

    new_user
  end

  def new_message(messages)
    Correspondence.create(
      sender: messages[0].keys.join,
      reciever: messages[1].keys.join,
      messages: messages,
      date: Time.now.iso8601
    )
  end

  def find_by_username(username)
    begin
    User.find_by(user_name: username)
    rescue
      Null
    end
  end
end
