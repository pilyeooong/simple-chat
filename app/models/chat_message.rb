class ChatMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :deleted_at, type: DateTime

  belongs_to :chat_room, index: true
  belongs_to :user, index: true

  index({ deleted_at: 1 })

end
