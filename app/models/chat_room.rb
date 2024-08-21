class ChatRoom
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :participants_count, type: Integer, default: 0
  field :deleted_at, type: DateTime

  has_many :chat_messages
  belongs_to :admin, class_name: "User"

  index({ deleted_at: 1 })
  index({ id: 1, deleted_at: 1 })
  index({ name: 1 }, { unique: true })
end
