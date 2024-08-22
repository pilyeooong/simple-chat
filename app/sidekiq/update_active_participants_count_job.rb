class UpdateActiveParticipantsCountJob
  include Sidekiq::Job

  def perform
    current_time = Time.zone.now.to_i
    thirty_minutes_ago = current_time - 1800

    chat_rooms = ChatRoom.where(deleted_at: nil)
    chat_rooms.each do |chat_room|
      REDIS.zremrangebyscore(CachePolicy.chat_room_active_users(chat_room.id.to_s), 0, thirty_minutes_ago)
      active_participants_count = REDIS.zcount(CachePolicy.chat_room_active_users(chat_room.id.to_s), thirty_minutes_ago, current_time)
      chat_room.update!(active_participants_count: active_participants_count)
    end
  rescue Exception => e
    error_message = e.message + "\n" + e.backtrace.join("\n")
    Rails.logger.error(error_message)
  end
end
