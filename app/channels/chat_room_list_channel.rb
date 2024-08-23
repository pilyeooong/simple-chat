class ChatRoomListChannel < ApplicationCable::Channel
  def subscribed
    stream_from ChannelPolicy.chat_room_list_channel
  end

  def unsubscribed
  end
end
