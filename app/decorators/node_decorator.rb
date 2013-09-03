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

  # Build HTML lists for the accordion on the top page. The list begins at [self]
  #
  # @return [String]
  def build_accordion
    out = ''
    before_tag = "<ul id='accordion' class='accordion-nav'>"
    after_tag  = "</ul>"
    out += self.decorate.accordion_item_with_remain_depth(3, before_tag, after_tag) do |node, remain_depth|
      if node.is_a? Graph
        node.decorate.accordion_graph_node
      elsif remain_depth > 1
        node.decorate.accordion_opened_node
      else
        node.decorate.accordion_closed_node
      end
    end
  end

  # Return an opened node of the accordion.
  #
  # @return [String]
  def accordion_opened_node
    out = <<-EOS
      <div class='accordion-head' data-path='#{h.h(self.path)}'>
        <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
        <span class='accordion-nav-arrow accordion-nav-arrow-rotate'></span>
      </div>
    EOS
  end

  # Return a closed node of the accordion.
  #
  # @return [String]
  def accordion_closed_node
    out = <<-EOS
      <div class='accordion-head' data-path='#{h.h(self.path)}'>
        <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
        <span class='accordion-nav-arrow'></span>
      </div>
    EOS
  end

  # Return a graph node of the accordion.
  #
  # @return [String]
  def accordion_graph_node
    out = <<-EOS
      <div class='accordion-nav-leaf' data-path='#{h.h(self.path)}'>
        <a href="#{h.list_graph_path(self.path)}">#{self.basename}</a>
        <span></span>
      </div>
    EOS
  end

  # Build the lists for the accordion recursively.
  # @param remain_depth [Integer] how much depth to create 
  # @param before_tag [String] put the string before <li>..</li>. Basically, '<ul>' is given.
  # @param after_tag [String] put the string after <li>..</li>. Basically, '<ul>' is given.
  # @parma &blk Block must be givien, be HTML string. It is inserted to the inside of <li>.
  #
  # @return [String]
  def accordion_item_with_remain_depth(remain_depth = 1, before_tag = '', after_tag = '', &blk)
    out = ''
    out += before_tag
    if remain_depth > 0
      self.children.each do |node|
        out += '<li>'
        out += blk.call(node, remain_depth)
        out += node.decorate.accordion_item_with_remain_depth(remain_depth - 1, "<ul class='accordion-nav'>", "</ul>", &blk)
        out += "</li>"
      end
    end
    out += after_tag
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
