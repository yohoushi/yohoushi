module GraphsHelper
  include ActsAsTaggableOn::TagsHelper

  def link(path)
    if path.root?
      link_to(path.fullpath, root_url)
    elsif path.directory?
      link_to(path.fullpath, list_graph_path(path.fullpath))
    else
      link_to(path.fullpath, view_graph_path(path.fullpath))
    end
  end

  def tree(root)
    html = ''
    open_ul = 0
    prev_depth = root.depth - 1
    root.subtree.each do |path|
      curr_depth = path.depth
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
      html += link(path)
    end
    html += '</li></ul>' * open_ul.abs
    html
  end
end
