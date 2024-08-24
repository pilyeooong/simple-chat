module Errors
  INVALID_REQUEST = 400
  INVALID_REQUEST_MESSAGE = "Invalid Request"

  FORBIDDEN = 403
  FORBIDDEN_MESSAGE = "Forbidden"

  NOT_EXIST = 404

  CHAT_ROOM_NOT_EXIST_MESSAGE = "채팅방이 존재하지 않습니다."
  USER_NOT_EXIST_MESSAGE = "유저가 존재하지 않습니다."

  NAME_FIELD_REQUIRED_MESSAGE = "name 필드는 필수값입니다."
  DESCRIPTION_FIELD_REQUIRED_MESSAGE = "description 필드는 필수값입니다."
  CHAT_ROOM_ALREADY_EXISTS_MESSAGE = "동일한 이름의 채팅방이 이미 존재합니다."

  class Forbidden < StandardError
    def message
      FORBIDDEN_MESSAGE
    end

    def error_code
      FORBIDDEN
    end
  end

  class InvalidRequest < StandardError
    def initialize(message = INVALID_REQUEST_MESSAGE)
      super(message)
    end

    def error_code
      INVALID_REQUEST
    end
  end

  class NotExist < StandardError
    def initialize(message)
      super(message)
    end

    def error_code
      NOT_EXIST
    end
  end
end
