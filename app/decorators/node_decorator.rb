class NodeDecorator < Draper::Decorator
  delegate_all

  def link_to
    if self.root?
      h.link_to(self.basename, h.root_path)
    elsif self.has_children?
      h.link_to(self.basename, h.list_path(self.path))
    else
      h.link_to(self.basename, h.view_path(self.path))
    end
  end

  # Show ActiveModel::Errors
  def view_errors
    self.errors.full_messages.sort{|a,b| a.downcase <=> b.downcase }.join("<br />") if errors.present?
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
