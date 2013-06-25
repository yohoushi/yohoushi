class ResourceDecorator < Draper::Decorator
  delegate_all

  # Show ActiveModel::Errors
  def view_errors
    self.errors.full_messages.sort{|a,b| a.downcase <=> b.downcase }.join("<br />") if errors.present?
  end

end
