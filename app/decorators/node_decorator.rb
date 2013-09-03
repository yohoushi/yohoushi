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

  def build_accordion
    out = ''
    out += "<ul id='accordion.accordion-nav' class='accordion-nav'>"
    out += self.decorate.build_accordion_item_with_remain_depth(3) do |node, remain_depth|
      if node.is_a? Graph
        node.decorate.accordion_node_graph
      elsif remain_depth > 1
        node.decorate.accordion_node_opened
      else
        node.decorate.accordion_node_closed
      end
    end
    out += "</ul>"
  end

  def accordion_node_opened
    out = <<-EOS
      <div class='accordion-head' data-path='#{h.h(self.path)}'>
        <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
        <span class='accordion-nav-arrow accordion-nav-arrow-rotate'></span>
      </div>
    EOS
  end

  def accordion_node_closed
    out = <<-EOS
      <div class='accordion-head' data-path='#{h.h(self.path)}'>
        <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
        <span class='accordion-nav-arrow'></span>
      </div>
    EOS
  end

  def accordion_node_graph
    out = <<-EOS
      <div class='accordion-nav-leaf' data-path='#{h.h(self.path)}'>
        <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
        <span></span>
      </div>
    EOS
  end

  def build_accordion_item_with_remain_depth(remain_depth = 1, &blk)
    out = ''
    return '' if remain_depth == 0
    self.children.each do |node|
      out += '<li>'
      out += blk.call(node, remain_depth)
      out += "<ul class='accordion-nav'>"
      out += build_accordion_item_with_remain_depth(remain_depth - 1, &blk)
      out += "</ul>"
      out += "</li>"
    end
    out
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
