require 'mongoid'


Mongoid.load!('mongoid.yml', :production)

class Correspondance
    include Mongoid::Document

  field :user_name,type: String
  field :to,type: String
  field :date, type: Date
  field :decodedmessage, type: String
  field :codedmessage, type: String

end


class User 
  include Mongoid::Document

  field :user_name,type: String
  field :public_key,type: String
  field :conversation_ids,type: Array
  field :password,type: String

end



