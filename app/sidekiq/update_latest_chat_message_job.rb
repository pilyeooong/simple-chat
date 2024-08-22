class UpdateLatestChatMessageJob
  include Sidekiq::Job

  def perform(args)
    chat_room_id = args["chat_room_id"]
    chat_message = args["chat_message"]

    chat_room = ChatRoom.find_by(id: chat_room_id)
    return if chat_room.nil?

    chat_room.update!(latest_chat_message: chat_message)

    # 채팅방의 latest_chat_message 필드 업데이트 후, 채팅방 리스트 채널에 업데이트 내용을 브로드캐스팅한다.
    ActionCable.server.broadcast(ChannelPolicy.chat_room_list_channel, {
      chat_room: chat_room.as_json,
    })

    return
  rescue Exception => e
    error_message = e.message + "\n" + e.backtrace.join("\n")
    Rails.logger.error(error_message)
  end
end
