10.times do |n|
  user = User.find_or_create_by!(id: (n+1).to_s, nickname: "test#{n+1}", email: "test#{n+1}@gmail.com")
  ChatRoom.find_or_create_by!(
    id: (n+1).to_s,
    name: "test#{n+1}",
    description: "test#{n+1}",
    admin: user,
    updated_at: Time.zone.now - n+1.days
  )
end
