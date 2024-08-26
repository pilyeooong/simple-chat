require "rails_helper"

RSpec.describe ChatRoomListChannel, type: :channel do
  it "successfully subscribes and streams from the correct chat room list channel" do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from(ChannelPolicy.chat_room_list_channel)
  end

  it "broadcasts a message to the correct chat room list channel" do
    user = create(:user)
    chat_room = create(:chat_room, admin: user)

    chat_room_obj = chat_room.as_json

    expect {
      ActionCable.server.broadcast(ChannelPolicy.chat_room_list_channel, {
        chat_room: chat_room_obj
      })
    }.to have_broadcasted_to(ChannelPolicy.chat_room_list_channel).with(chat_room: chat_room_obj)
  end
end
