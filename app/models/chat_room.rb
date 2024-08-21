class ChatRoom
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :participants_count, type: Integer, default: 0

  has_many :chat_messages
  belongs_to :admin, class_name: 'User'
end
