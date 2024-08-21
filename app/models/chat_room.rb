class ChatRoom
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :name, type: String
  field :description, type: String
  field :participants_count, type: Integer, default: 0

  has_many :chat_messages
end
