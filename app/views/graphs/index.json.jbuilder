json.array!(@graphs) do |graph|
  json.extract! graph, :path
  json.url graph_url(graph, format: :json)
end
