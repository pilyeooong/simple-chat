class ApplicationController < ActionController::API
  rescue_from Exception, with: :handle_error

  def handle_error(e)
    render json: { message: e.message }, status: :internal_server_error
  end
end
