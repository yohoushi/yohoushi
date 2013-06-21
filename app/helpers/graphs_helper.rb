module GraphsHelper
  include ActsAsTaggableOn::TagsHelper

  def link_to_node(node)
    if node.root?
      link_to(node.basename, root_url)
    elsif node.section?
      link_to(node.basename, list_graph_path(node.path))
    else
      link_to(node.basename, view_graph_path(node.path))
    end
  end

  def tree(root, depth = 5)
    return '' unless root
    subtree = (depth.present? ? root.subtree(to_depth: depth) : root.subtree).order('path ASC')
    html = ''
    open_ul = 0
    prev_depth = root.depth - 1
    subtree.each do |node|
      curr_depth = node.depth
      diff = curr_depth - prev_depth
      if curr_depth > prev_depth
        html += '<ul><li style="list-style:none">' * (diff - 1).abs
        html += node.graph? ? '<ul><li class="graph">' : '<ul><li>'
        open_ul += diff
      elsif curr_depth == prev_depth
        html += node.graph? ? '</li><li class="graph">' : '</li><li>'
      elsif curr_depth < prev_depth
        html += '</li></ul>' * diff.abs
        html += node.graph? ? '</li><li class="graph">' : '</li><li>'
        open_ul -= diff
      end
      prev_depth = curr_depth
      html += link_to_node(node)
    end
    html += '</li></ul>' * open_ul.abs
    html
  end

  # @param path [String] like 'a/b/c'
  # @return full uri path [String] like 'http://10.33.49.163:5125/graph/mfclient/a%252Fb%252Fc/d?t=d'
  def graph_uri_for(path)
    $mfclient.get_graph_uri(path, @graph_uri_params)
  end

  def select_tag_for_term
    html = ''
    html += '<select name="t">'
    Settings.graph.date_period_terms.each do |term|
      selected = (term[:short_name] == @term) ? 'selected="selected"' : ''
      html += %!<option class="span2" value="#{term[:short_name]}" #{selected}>#{term[:name]}</option>!
    end
    html += '</select>'
    html
  end

  def select_tag_for_size
    html = ''
    html += '<select name="size">'
    Settings.graph.sizes.sort{|(k1, v1), (k2, v2)| v1['width'] <=> v2['width']}.each do |size, v|
      selected = (size == @size) ? 'selected="selected"' : ''
      html += %!<option class="span2" value="#{size}" #{selected}>#{size}</option>!
    end
    html += '</select>'
    html
  end

end
