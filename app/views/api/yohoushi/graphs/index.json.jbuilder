json.array!(@graphs) do |graph|
  json.extract! graph, :path
  json.uri api_yohoushi_graphs_url + '/' + graph.path
end
