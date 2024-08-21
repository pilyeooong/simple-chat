class ChatRoomsController < ApplicationController
  def index
    page = params[:page]
    limit = params[:limit]

    chat_rooms = ChatRoom.offset((page - 1) * limit).limit(limit)

    render json: { chat_rooms: chat_rooms }, status: :ok
  end

  def detail
    chat_room_id = params[:chat_room_id]
    chat_room = ChatRoom.find_by(id: chat_room_id)

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
