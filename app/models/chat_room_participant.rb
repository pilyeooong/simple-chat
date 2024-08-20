class ChatRoomParticipant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :last_active_at, type: DateTime

  belongs_to :chat_room, index: true
  belongs_to :user, index: true

  index({ chat_room_id: 1, user_id: 1 }, { unique: true })
end
