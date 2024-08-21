Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get "up" => "rails/health#show", as: :rails_health_check

  get "chat_rooms", to: "chat_rooms#index"
  get "chat_rooms/:id", to: "chat_rooms#detail"

  post "chat_rooms/:chat_room_id/messages", to: "chat_messages#create"
end
