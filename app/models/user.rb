class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname, type: String
  field :email, type: String

  index({ nickname: 1 }, unique: true)
  index({ email: 1 }, unique: true)
end
