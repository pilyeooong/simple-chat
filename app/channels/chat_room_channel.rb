class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    chat_room_id = params[:chat_room_id]
    chat_room = ChatRoom.find_by(id: chat_room_id)
    reject if chat_room.nil?

    stream_from ChannelPolicy.chat_room_channel(chat_room.id.to_s)
  end

  def unsubscribed
  end
end


