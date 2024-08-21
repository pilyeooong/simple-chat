module Errors
  INVALID_REQUEST = 400
  INVALID_REQUEST_MESSAGE = "Invalid Request"

  FORBIDDEN = 403
  FORBIDDEN_MESSAGE = "Forbidden"

  NOT_EXIST = 404

  CHAT_ROOM_NOT_EXIST_MESSAGE = "채팅방이 존재하지 않습니다."
  USER_NOT_EXIST_MESSAGE = "유저가 존재하지 않습니다."

  class Forbidden < StandardError
    def message
      FORBIDDEN_MESSAGE
    end

    def error_code
      FORBIDDEN
    end
  end

  class InvalidRequest < StandardError
    def message
      INVALID_REQUEST_MESSAGE
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
