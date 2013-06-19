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

  # determin graph image uri
  #
  # @param path [String] like 'a/b/c'
  # @return full uri path [String] like 'http://10.33.49.163:5125/graph/mfclient/a%252Fb%252Fc/d?t=d'
  def graph_image_uri_for(path)
    # @image_uri_proc is initialized at app/controllers/graphs_controller.rb
    @image_uri_proc.call(path)
  end

  def select_tag_for_preset
    collection_select(
      :filter,
      :preset,
      Settings.graph.date_period_presets,
      :short_name,
      :name,
      {:selected => lambda {|p| p[:short_name] == @preset }},
      {:class => 'span2'},
    )
  end

  def select_tag_for_size
    collection_select(
      :filter,
      :size,
      Settings.graph.sizes,
      :name,
      :name,
      {:selected => lambda {|s| s[:name] == @size}},
      {:class => 'span2'},
    )
  end

end
