module ApplicationHelper
  def current_path(options = {})
    options = request.params.symbolize_keys.merge(options)
    url_for Rails.application.routes.recognize_path(request.path).merge(options)
  end
end
