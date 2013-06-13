class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

#  rescue_from NotFound do |e|
#    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
#  end
  rescue_from GrowthForecast::Error do |e|
    render json: {'message' => e.message}, status: :unprocessable_entity
  end
  rescue_from GrowthForecast::NotFound do |e|
    render json: {'message' => e.message}, status: 404
  end
  rescue_from GrowthForecast::AlreadyExists do |e|
    render json: {'message' => e.message}, status: 409
  end
end
