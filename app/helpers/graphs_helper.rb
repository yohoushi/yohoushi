module GraphsHelper
  include ActsAsTaggableOn::TagsHelper

  # @param graph [Graph]
  # @return full uri path [String] like 'http://10.33.49.163:5125/graph/mfclient/a%252Fb%252Fc/d?t=d'
  def graph_uri_for(graph)
    current_params = params["action"] == 'view_graph' ?
      @graph_parameter.view_graph_uri_params :
      @graph_parameter.list_graph_uri_params

    if Settings.proxy
      if graph.complex
        proxy_complex_path(graph.path, current_params)
      else
        proxy_graph_path(graph.path, current_params)
      end
    else
      if graph.complex
        $mfclient.get_complex_uri(graph.path, current_params)
      else
        $mfclient.get_graph_uri(graph.path, current_params)
      end
    end
  end

  def select_tag_for_term
    html = ''
    html += '<select name="t" id="select-term">'
    GraphSettings.date_period_terms.each do |term|
      selected = (term[:short_name] == @graph_parameter.term) ? 'selected="selected"' : ''
      html += %!<option class="span2" value="#{term[:short_name]}" #{selected}>#{term[:name]}</option>!
    end
    html += '</select>'
    html
  end

  def select_tag_for_size
    current_size = (params["action"] == 'view_graph' ? @graph_parameter.view_size : @graph_parameter.list_size)
    html = ''
    html += '<select name="size" id="select-size">'
    GraphSettings.sizes.sort{|(k1, v1), (k2, v2)| v1['width'] <=> v2['width']}.each do |size, v|
      selected = (size == current_size) ? 'selected="selected"' : ''
      html += %!<option class="span2" value="#{size}" #{selected}>#{size}</option>!
    end
    html += '</select>'
    html
  end

end
