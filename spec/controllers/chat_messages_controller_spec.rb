require "rails_helper"

RSpec.describe ChatMessagesController, type: :controller do
  describe "ChatMessagesController" do
    before(:each) do
      Mongoid.purge!
    end

    it "send message to chat room" do
      user = create(:user)
      chat_room = create(:chat_room, admin: user)

      content = "message !"

      post :create, params: { user_id: user.id.to_s, chat_room_id: chat_room.id.to_s, content: content }

      parsed_body = JSON.parse(response.body)
      message_content = parsed_body["chat_message"]["content"]

      expect(chat_room.chat_messages.size).not_to eq(0)
      expect(message_content).to eq(content)
    end
  end
end
