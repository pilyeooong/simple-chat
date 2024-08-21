class ChatRoomsController < ApplicationController
  def index
    page = params[:page]
    limit = params[:limit]

    if page.present?
      page = page.to_i
    else
      page = 1
    end

    if limit.present?
      limit = limit.to_i
    else
      limit = 20
    end

    chat_rooms = ChatRoom.where(deleted_at: nil).order(created_at: :desc).offset((page - 1) * limit).limit(limit)

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

    CountChatRoomParticipantsJob.perform_async({ chat_room_id: chat_room.id.to_s }.as_json)

    render json: { chat_room_participant: chat_room_participant }, status: :ok
  end
end
