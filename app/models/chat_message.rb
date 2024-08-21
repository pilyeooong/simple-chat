class ChatMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  belongs_to :chat_room, index: true
  belongs_to :user, index: true
end
