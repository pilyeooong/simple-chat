class CountChatRoomParticipantsJob
  include Sidekiq::Job

  def perform(args)
    chat_room_id = args["chat_room_id"]

    chat_room = ChatRoom.find_by(id: chat_room_id)
    return if chat_room.nil?

    chat_room_participants_count = ChatRoomParticipant.where(chat_room_id: chat_room_id).count
    pp chat_room_participants_count

    chat_room.update!(participants_count: chat_room_participants_count)

    return
  rescue Exception => e
    pp e
  end
end
