module GraphsHelper
  include ActsAsTaggableOn::TagsHelper

  def link_to_node(node)
    if node.root?
      link_to(node.basename, root_url)
    elsif node.directory?
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
        html += '<ul><li>'
        open_ul += diff
      elsif curr_depth == prev_depth
        html += '</li><li>'
      elsif curr_depth < prev_depth
        html += '</li></ul>' * diff.abs
        html += '</li><li>'
        open_ul -= diff
      end
      prev_depth = curr_depth
      html += link_to_node(node)
    end
    html += '</li></ul>' * open_ul.abs
    html
  end
end
