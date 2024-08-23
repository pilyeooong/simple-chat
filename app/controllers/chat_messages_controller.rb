class ChatMessagesController < ApplicationController
  def index
    chat_room_id = params[:chat_room_id]
    time_cursor = params[:time_cursor]
    limit = params[:limit]

    time_cursor = Time.zone.now if time_cursor.blank?

    if limit.present?
      limit = limit.to_i
    else
      limit = 30
    end

    chat_room = ChatRoom.find_by(id: chat_room_id, deleted_at: nil)
    raise Errors::NotExist.new(Errors::CHAT_ROOM_NOT_EXIST_MESSAGE) if chat_room.nil?

    chat_messages = ChatMessage
                      .where(chat_room: chat_room, deleted_at: nil, created_at: { "$lt": time_cursor })
                      .order(created_at: :desc)
                      .limit(limit)

    render json: { chat_messages: chat_messages }, status: :ok
  end

  def create
    chat_room_id = params[:chat_room_id]
    user_id = params[:user_id]
    content = params[:content]

    chat_room = ChatRoom.find_by(id: chat_room_id, deleted_at: nil)
    raise Errors::NotExist.new(Errors::CHAT_ROOM_NOT_EXIST_MESSAGE) if chat_room.nil?

    user = User.find_by(id: user_id, deleted_at: nil)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if chat_room.nil?

    chat_room_participant = ChatRoomParticipant.find_by(chat_room_id: chat_room_id, user_id: user_id)
    raise Errors::Forbidden.new if chat_room_participant.nil?

    chat_message = ChatMessage.create!(user: user, chat_room: chat_room, content: content)

    UpdateLastActiveAtJob.perform_async({ chat_room_id: chat_room.id.to_s, user_id: user.id.to_s }.as_json)
    UpdateLatestChatMessageJob.perform_async({ chat_room_id: chat_room.id.to_s, chat_message: chat_message.as_json }.as_json)

    # 채팅 메시지를 생성 및 DB에 저장한 후, 해당 채팅방 채널에 메시지 내용을 브로드캐스팅한다.
    chat_message_obj = chat_message.as_json
    chat_message_obj["user"] = user.as_json
    ActionCable.server.broadcast(ChannelPolicy.chat_room_channel(chat_room.id.to_s), {
      chat_message: chat_message_obj,
    })

    render json: { chat_message: chat_message }, status: :ok
  end
end
