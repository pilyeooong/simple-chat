Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get "up" => "rails/health#show", as: :rails_health_check

  post "chat_rooms/:chat_room_id/messages", to: "chat_messages#create"
end
