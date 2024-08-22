require "rails_helper"

RSpec.describe UpdateLatestChatMessageJob, type: :job do
  before(:each) do
    Mongoid.purge!
  end

  describe "UpdateLatestChatMessageJob" do
    it "update latest chat message job" do
      user = create(:user)
      chat_room = create(:chat_room, admin: user)
      create(:chat_room_participant, user: user, chat_room: chat_room)
      chat_message = create(:chat_message, user: user, chat_room: chat_room, content: "content")

      UpdateLatestChatMessageJob.perform_sync({ chat_room_id: chat_room.id.to_s, chat_message: chat_message.as_json }.as_json)

      chat_room.reload

      expect(chat_room.latest_chat_message).not_to be_nil
    end
  end
end
