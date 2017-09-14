require 'mongoid'


Mongoid.load!('mongoid.yml', :production)

#Both of the message fields will be encrypted using pgp
#messages are hashes of key values pairs 
#key will denote the person who can decrypt message
class Correspondance
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

  field :sender,type:String,
  field :reciever,type:String,
  field :messages,type:Array #{User1 <= codedmessage,User2 <= coded_message}
  field :date, type: Time

end


class User 
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :user_name,type: String
  field :public_key,type: String
  field :password_hash,type: String
  field :password_salt,type: String

end



