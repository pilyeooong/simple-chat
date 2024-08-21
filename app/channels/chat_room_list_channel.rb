class ChatRoomListChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_room_list"
  end

  def unsubscribed
  end
end
