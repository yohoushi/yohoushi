json.array!(@graphs) do |graph|
  # json.extract! graph, :path, :gfuri
  # json.url graph_url(graph, format: :json)
  graph.each do |key, value|
    json.set!(key, graph[key])
  end
end
