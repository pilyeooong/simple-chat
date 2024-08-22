require "rails_helper"

RSpec.describe CountChatRoomParticipantsJob, type: :job do
  before(:each) do
    Mongoid.purge!
  end

  describe "CountChatRoomParticipantsJob" do
    it "count chat room participants" do
      admin = create(:user)
      chat_room = create(:chat_room, admin: admin)

      size = 5
      size.times do
        user = create(:user)
        create(:chat_room_participant, user: user, chat_room: chat_room)
      end

      CountChatRoomParticipantsJob.perform_sync({ chat_room_id: chat_room.id.to_s }.as_json)

      chat_room.reload

      expect(chat_room.total_participants_count).to eq(size)
    end
  end
end
