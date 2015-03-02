class NodeDecorator < ApplicationDecorator
  delegate_all

  def link_to
    h.link_to(self.basename, self.graph_path)
  end

  def graph_path
    if self.root?
      self.root_path
    elsif self.has_children?
      self.list_or_tree_graph_path
    else
      self.view_graph_path
    end
  end

  def list_or_tree_graph_path
    if Settings.try(:accordion).try(:link_to_tree_graph) and !self.has_graph_child?
      self.tree_graph_path
    else
      self.list_graph_path
    end
  end

  def view_graph_path
    h.view_graph_path(self.path, graph_parameter_view_params)
  end

  def root_path
    h.root_path(graph_parameter_list_params)
  end

  def tree_graph_path
    h.tree_graph_path(self.path, graph_parameter_list_params)
  end

  def list_graph_path
    h.list_graph_path(self.path, graph_parameter_list_params)
  end

  def tag_graph_path(tag_list)
    if tag_list.present?
      h.tag_graph_path(tag_list, graph_parameter_list_params)
    else
      h.tag_graph_root_path(graph_parameter_list_params)
    end
  end

  def setup_graph_path
    h.setup_graph_path(self.path)
  end

  def graph_parameter_view_params
    # ToDo: we would cache this `params` because this is common in all model entities, but maybe trivial
    h.session[:graph_parameter].try(:to_view_params)
  end

  def graph_parameter_list_params
    # ToDo: we would cache this `params` because this is common in all model entities, but maybe trivial
    h.session[:graph_parameter].try(:to_list_params)
  end

  def anchor_to(path = nil)
    if path
      "<a class='anchor' name='#{self.basename(path)}' href='##{self.basename(path)}'>#{self.basename(path)}</a>"
    else
      "<a class='anchor' name='#{self.path}' href='##{self.path}'>#{self.path}</a>"
    end
  end

  # Build HTML lists for the accordion on the top page. The list begins at [self]
  # @param depth [Integer] depth of the accordion to show when load the top page.
  #
  # @return [String]
  def build_accordion(depth)
    out = '<ul id="accordion" class="accordion-nav">'
    out += self.decorate.build_accordion_recursively(depth)
    out += '</ul>'
  end

  # Return an opened node of the accordion.
  #
  # @return [String]
  def accordion_opened_node
    out = <<-EOS
      <div class='accordion-head' data-path='#{h.h(self.path)}'>
        <a href="#{self.list_or_tree_graph_path}">#{self.basename}</a>
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
        <a href="#{self.list_or_tree_graph_path}">#{self.basename}</a>
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
        <a href="#{h.view_graph_path(self.path)}">#{self.basename}</a>
        <span></span>
      </div>
    EOS
  end

  # Build the lists for the accordion recursively.
  # @param depth [Integer] how much depth to create
  #
  # @return [String]
  def build_accordion_recursively(depth = 1)
    return '' if depth <= 0
    out = ''
    children = self.children.visible.order('path ASC, type DESC')
    Node.set_has_graph_child(children) if Settings.try(:accordion).try(:link_to_tree_graph)
    children.each do |node|
      out += '<li>'
      out += if node.is_a? Graph
               node.decorate.accordion_graph_node
             elsif depth > 1
               node.decorate.accordion_opened_node
             else
               node.decorate.accordion_closed_node
             end
      out += '<ul class="accordion-nav">'
      out += node.decorate.build_accordion_recursively(depth - 1)
      out += '</ul>'
      out += '</li>'
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
