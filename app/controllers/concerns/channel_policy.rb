module ChannelPolicy
  def self.chat_room_channel(chat_room_id)
    "chat_room_#{chat_room_id}"
  end

  def self.chat_room_list_channel
    "chat_room_list"
  end
end
