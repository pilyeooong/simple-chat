module CachePolicy
  def self.chat_room_active_users(chat_room_id)
    "chat_room:#{chat_room_id}:active_users"
  end

  def self.active_chat_rooms
    "active_chat_rooms"
  end
end
