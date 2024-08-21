require "rails_helper"

RSpec.describe ChatRoomsController, type: :controller do
  describe "ChatRoomsController" do
    before(:each) do
      Mongoid.purge!
    end

    it "list all chat rooms" do
      user = create(:user)
      size = 10
      size.times do
        create(:chat_room, admin: user)
      end

      get :index, params: { page: 1, limit: size }

      parsed_body = JSON.parse(response.body)
      chat_rooms = parsed_body["chat_rooms"]

      expect(chat_rooms).not_to be_nil
      expect(chat_rooms.size).to eq(size)
    end

    it "create chat room" do
      user = create(:user)

      name = "chat room name"
      description = "description"

      post :create, params: { user_id: user.id.to_s, name: name, description: description }

      parsed_body = JSON.parse(response.body)
      chat_room = parsed_body["chat_room"]

      expect(chat_room).not_to be_nil
    end

    it "return chat room detail" do
      user = create(:user)
      chat_room = create(:chat_room, admin: user)

      get :detail, params: { id: chat_room.id.to_s }

      parsed_body = JSON.parse(response.body)
      json_chat_room = parsed_body["chat_room"]

      expect(json_chat_room).not_to be_nil
      expect(json_chat_room["_id"]).to eq(chat_room.id.to_s)
    end

    it "should raise error if chat room not exists" do
      get :detail, params: { id: "invalid_id" }

      parsed_body = JSON.parse(response.body)
      error_message = parsed_body["error"]["message"]

      expect(error_message).to eq(Errors::CHAT_ROOM_NOT_EXIST_MESSAGE)
    end
  end
end
