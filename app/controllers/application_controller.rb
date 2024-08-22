class ApplicationController < ActionController::API
  rescue_from Exception, with: :handle_error

  def handle_error(e)
    error_message = e.message + "\n" + e.backtrace.join("\n")
    Rails.logger.error(error_message)
    render json: { error: { message: e.message } }, status: e.try(:code) || 500
  end
end
