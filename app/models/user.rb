class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname, type: String
  field :email, type: String
  field :deleted_at, type: DateTime

  index({ id: 1, deleted_at: 1 })
  index({ nickname: 1 }, unique: true)
  index({ email: 1 }, unique: true)
end
