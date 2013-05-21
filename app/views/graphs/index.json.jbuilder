json.array!(@graphs) do |graph|
  json.extract! graph, :path, :gfuri
  json.url graph_url(graph, format: :json)
end
