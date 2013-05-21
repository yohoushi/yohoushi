class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from GrowthForecast::NotFound do |e|
    render json: {'message' => e.message}, status: 404
  end
  rescue_from GrowthForecast::AlreadyExists do |e|
    render json: {'message' => e.message}, status: 409
  end
  rescue_from GrowthForecast::Error do |e|
    render json: {'message' => e.message}, status: :unprocessable_entity
  end
end
