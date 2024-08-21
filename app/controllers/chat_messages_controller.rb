class ChatMessagesController < ApplicationController
  def index
    chat_room_id = params[:chat_room_id]

    chat_room = ChatRoom.find_by(id: chat_room_id)
    raise Exception.new('ChatRoom Not Exists') if chat_room.nil?

    chat_messages = ChatMessage.where(chat_room: chat_room).order(created_at: :desc)

    render json: { chat_messages: chat_messages }, status: :ok
  end

  def create
    chat_room_id = params[:chat_room_id]
    user_id = params[:user_id]

    chat_room = ChatRoom.find_by(id: chat_room_id)
    raise Errors::NotFound.new("ChatRoom") if chat_room.nil?

    user = User.find_by(id: user_id)
    raise Errors::NotFound.new('User') if user.nil?

    chat_message = ChatMessage.create!(user: user, chat_room: chat_room, content: "Hello World! #{Time.zone.now.to_i}")

    ActionCable.server.broadcast("chat_room_#{chat_room.id.to_s}", {
      message: chat_message.content,
      user: user.as_json
    })

    render json: { chat_message: chat_message }, status: :ok
  end
end
