class ChatMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :deleted_at, type: DateTime

  belongs_to :chat_room, index: true
  belongs_to :user, index: true

  index({ chat_room: 1, deleted_at: 1, created_at: -1 })

end
