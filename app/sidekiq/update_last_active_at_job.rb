class UpdateLastActiveAtJob
  include Sidekiq::Job

  def perform(args)
    user_id = args["user_id"]
    chat_room_id = args["chat_room_id"]

    chat_room_participant = ChatRoomParticipant.find_by(chat_room_id: chat_room_id, user_id: user_id)
    return if chat_room_participant.nil?

    chat_room_participant.update!(last_active_at: Time.zone.now)
  rescue Exception => e
    error_message = e.message + "\n" + e.backtrace.join("\n")
    Rails.logger.error(error_message)
  end
end
