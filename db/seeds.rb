10.times do |n|
  User.find_or_create_by!(nickname: "test#{n+1}", email: "test#{n+1}@gmail.com")
  ChatRoom.find_or_create_by!(
    type: "test#{n+1}",
    name: "test#{n+1}",
    description: "test#{n+1}",
  )
end
