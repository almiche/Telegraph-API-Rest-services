require 'mongoid'


Mongoid.load!('mongoid.yml', :production)

#Both of the message fields will be encrypted using pgp
#messages are hashes of key values pairs 
#key will denote the person who can decrypt message
class Correspondance
    include Mongoid::Document

  field :user_name,type: String
  field :to,type: String
  field :date, type: Date
  field :decodedmessage, type: Hash
  field :codedmessage, type: Hash

end


class User 
  include Mongoid::Document

  field :user_name,type: String
  field :public_key,type: String
  field :correspondance_ids,type: Array
  field :password_hash,type: String
  field :password_salt,type: String

end



