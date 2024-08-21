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

    chat_rooms = ChatRoom.offset((page - 1) * limit).limit(limit)

    render json: { chat_rooms: chat_rooms }, status: :ok
  end

  def detail
    chat_room_id = params[:id]

    chat_room = ChatRoom.find_by(id: chat_room_id)
    raise Errors::NotExist.new(Errors::CHAT_ROOM_NOT_EXIST_MESSAGE) if chat_room.nil?

    render json: { chat_room: chat_room }, status: :ok
  end

  def create
    name = params[:name]
    description = params[:description]

    new_chat_room = ChatRoom.create!(name: name, description: description)

    render json: { chat_room: new_chat_room }, status: :created
  end

  def enter
  end
end
