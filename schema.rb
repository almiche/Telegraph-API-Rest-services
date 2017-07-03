require 'mongoid'


Mongoid.load!('mongoid.yml', :production)

# class MorseUsers
#   include Mongoid::Document
  
#   embeds_one:correspondance, :class_name => "Correspondance"
  
#   field :users, type:Array
#   store_in collection: 'morse_code',database:' mike'
# end

# class Correspondance
#     include Mongoid::Document

#   field :date, type: Date
#   field :decodedmessage, type: String
#   field :codedmessage, type: String

#   embedded_in :morseusers
# end

class Correspondance
    include Mongoid::Document

  field :user_name,type: String
  field :date, type: Date
  field :decodedmessage, type: String
  field :codedmessage, type: String

end






