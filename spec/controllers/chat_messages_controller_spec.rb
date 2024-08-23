require "rails_helper"

RSpec.describe ChatMessagesController, type: :controller do
  describe "ChatMessagesController" do
    before(:each) do
      Mongoid.purge!
    end

    it "list all chat messages" do
      user = create(:user)
      chat_room = create(:chat_room, admin: user)
      create(:chat_room_participant, user: user, chat_room: chat_room)

      20.times do |n|
        create(:chat_message, chat_room: chat_room, user: user, content: "message #{n+1}!", created_at: Time.zone.now - (n + 1).minutes)
      end

      get :index, params: {chat_room_id: chat_room.id.to_s, limit: 2, time_cursor: Time.zone.now - 2.minutes }

      parsed_body = JSON.parse(response.body)
      pp parsed_body
    end

    it "send message to chat room" do
      user = create(:user)
      chat_room = create(:chat_room, admin: user)
      create(:chat_room_participant, user: user, chat_room: chat_room)

      content = "message !"

      post :create, params: { user_id: user.id.to_s, chat_room_id: chat_room.id.to_s, content: content }

      parsed_body = JSON.parse(response.body)
      message_content = parsed_body["chat_message"]["content"]

      expect(chat_room.chat_messages.size).not_to eq(0)
      expect(message_content).to eq(content)
    end

    it "should raise error if chat room not exists" do
      user = create(:user)

      content = "message !"

      post :create, params: { user_id: user.id.to_s, chat_room_id: "invalid", content: content }

      parsed_body = JSON.parse(response.body)
      error_message = parsed_body["error"]["message"]

      expect(error_message).to eq(Errors::CHAT_ROOM_NOT_EXIST_MESSAGE)
    end

    it "should raise error if user not participate to chat room" do
      user = create(:user)
      chat_room = create(:chat_room, admin: user)

      content = "message !"

      post :create, params: { user_id: user.id.to_s, chat_room_id: chat_room.id.to_s, content: content }

      parsed_body = JSON.parse(response.body)
      error_message = parsed_body["error"]["message"]

      expect(error_message).to eq(Errors::FORBIDDEN_MESSAGE)

    end
  end
end
