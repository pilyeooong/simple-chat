class ChatRoom
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :total_participants_count, type: Integer, default: 0 # 입장한 모든 유저의 수
  field :active_participants_count, type: Integer, default: 0 # 최근 (30분 내) 접속자 수를 기록할 필드
  field :latest_chat_message, type: Object
  field :deleted_at, type: DateTime

  has_many :chat_messages
  belongs_to :admin, class_name: "User"

  index({ deleted_at: 1 })
  index({ id: 1, deleted_at: 1 })
  index({ name: 1 }, { unique: true })
end
