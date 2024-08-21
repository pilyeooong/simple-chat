Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get "up" => "rails/health#show", as: :rails_health_check

  get "chat_rooms", to: "chat_rooms#index"
  post "chat_rooms", to: "chat_rooms#create"
  get "chat_rooms/:id", to: "chat_rooms#detail"
  post "chat_rooms/:id/participate", to: "chat_rooms#participate"

  post "chat_rooms/:chat_room_id/messages", to: "chat_messages#create"
end
