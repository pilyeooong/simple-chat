module Errors
  INVALID_REQUEST = 400
  INVALID_REQUEST_MESSAGE = "Invalid Request"

  FORBIDDEN = 403
  FORBIDDEN_MESSAGE = "Forbidden"

  NOT_EXISTS = 404

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

  class NotFound < StandardError
    def initialize(item)
      @item = item
    end

    def message
      "#{@item} not exists"
    end

    def error_code
      NOT_FOUND
    end
  end
end
