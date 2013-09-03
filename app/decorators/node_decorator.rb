class NodeDecorator < ApplicationDecorator
  delegate_all

  def link_to
    if self.root?
      h.link_to(self.basename, h.root_path)
    elsif self.has_children?
      h.link_to(self.basename, h.list_graph_path(self.path))
    else
      h.link_to(self.basename, h.view_graph_path(self.path))
    end
  end

  def anchor_to(path = nil)
    if path
      "<a class='anchor' name='#{self.basename(path)}' href='##{self.basename(path)}'>#{self.basename(path)}</a>"
    else
      "<a class='anchor' name='#{self.path}' href='##{self.path}'>#{self.path}</a>"
    end
  end


  def accordion_node_opened
    out = <<-EOS
      <li>
        <div class='accordion-head' data-path='#{h.h(self.path)}'>
          <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
          <span class='accordion-nav-arrow accordion-nav-arrow-rotate'></span>
        </div>
        <ul class='accordion-nav' style='display:none;'></ul>
      </li>
    EOS
  end

  def accordion_node_closed
    out = <<-EOS
      <li>
        <div class='accordion-head' data-path='#{h.h(self.path)}'>
          <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
          <span class='accordion-nav-arrow'></span>
        </div>
        <ul class='accordion-nav' style='display:none;'></ul>
      </li>
    EOS
  end

  def accordion_node_graph
    out = <<-EOS
      <li>
        <div class='accordion-nav-leaf' data-path='#{h.h(self.path)}'>
          <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
          <span></span>
        </div>
      </li>
    EOS
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
