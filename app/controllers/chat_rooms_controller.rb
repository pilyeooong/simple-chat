class ChatRoomsController < ApplicationController
  def index
    limit = params[:limit]
    participants_count_cursor = params[:participants_count_cursor]
    time_cursor = params[:time_cursor]

    if limit.present?
      limit = limit.to_i
    else
      limit = 30
    end

    # TODO: 쿼리 검증 필요
    query_params = {}
    query_params[:deleted_at] = nil
    query_params[:active_participants_count] = { "$lte": participants_count_cursor } if participants_count_cursor.present?
    query_params[:updated_at] = { "$lt": time_cursor } if participants_count_cursor.present?
    # query_params[:"$or"] = [{ latest_chat_message: nil }, { "latest_chat_message.created_at": { "$lt": Time.at(timestamp_cursor.to_i) }}] if timestamp_cursor.present?

    chat_rooms = ChatRoom
                   .where(query_params)
                   .order(active_participants_count: :desc, "latest_chat_message.created_at": :desc)
                   .limit(limit)

    render json: { chat_rooms: chat_rooms }, status: :ok
  end

  def detail
    chat_room_id = params[:id]

    chat_room = ChatRoom.find_by(id: chat_room_id)
    raise Errors::NotExist.new(Errors::CHAT_ROOM_NOT_EXIST_MESSAGE) if chat_room.nil?

    render json: { chat_room: chat_room }, status: :ok
  end

  def create
    user_id = params[:user_id]
    name = params[:name]
    description = params[:description]

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    new_chat_room = ChatRoom.create!(name: name, description: description, admin: user)

    render json: { chat_room: new_chat_room }, status: :created
  end

  def participate
    chat_room_id = params[:id]
    user_id = params[:user_id]

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    chat_room = ChatRoom.find_by(id: chat_room_id)
    raise Errors::NotExist.new(Errors::CHAT_ROOM_NOT_EXIST_MESSAGE) if chat_room.nil?

    chat_room_participant = ChatRoomParticipant.find_or_create_by!(user: user, chat_room: chat_room)

    UpdateLastActiveAtJob.perform_async({ chat_room_id: chat_room.id.to_s, user_id: user.id.to_s }.as_json)
    CountChatRoomParticipantsJob.perform_async({ chat_room_id: chat_room.id.to_s }.as_json)

    # 접속 기록
    REDIS.zadd(CachePolicy.active_chat_rooms, Time.zone.now.to_i, chat_room.id.to_s)
    REDIS.zadd(CachePolicy.chat_room_active_users(chat_room.id.to_s), Time.zone.now.to_i, user.id.to_s)

    render json: { chat_room_participant: chat_room_participant }, status: :ok
  end
end
