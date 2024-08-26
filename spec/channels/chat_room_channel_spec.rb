require 'rails_helper'

RSpec.describe ChatRoomChannel, type: :channel do
  it "successfully subscribes and streams from the correct chat room channel" do
    user = create(:user)
    chat_room = create(:chat_room, admin: user)

    subscribe(chat_room_id: chat_room.id)

    pp subscription

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from(ChannelPolicy.chat_room_channel(chat_room.id.to_s))
  end

  it "broadcasts a message to the correct chat room channel" do
    user = create(:user)
    chat_room = create(:chat_room, admin: user)
    chat_message = create(:chat_message, chat_room: chat_room, user: user)

    chat_message_obj = chat_message.as_json

    expect {
      ActionCable.server.broadcast(ChannelPolicy.chat_room_channel(chat_room.id.to_s), {
        chat_message: chat_message_obj
      })
    }.to have_broadcasted_to(ChannelPolicy.chat_room_channel(chat_room.id.to_s)).with(chat_message: chat_message_obj)
  end
end
