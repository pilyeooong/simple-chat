require "rails_helper"

RSpec.describe UpdateLastActiveAtJob, type: :job do
  before(:each) do
    Mongoid.purge!
  end

  describe "UpdateLastActiveAtJob" do
    it "update last active at field" do
      user = create(:user)
      chat_room = create(:chat_room, admin: user)
      chat_room_participant = create(:chat_room_participant, chat_room: chat_room, user: user)

      UpdateLastActiveAtJob.perform_sync({ chat_room_id: chat_room.id.to_s, user_id: user.id.to_s }.as_json)

      chat_room_participant.reload

      expect(chat_room_participant.last_active_at).not_to be_nil
    end
  end
end
