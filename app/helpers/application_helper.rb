module ApplicationHelper
  def current_path(options = {})
    url_for request.params.symbolize_keys.merge(options)
  end
end
