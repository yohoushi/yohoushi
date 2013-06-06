json.array!(@graphs) do |graph|
  json.extract! graph, :fullpath
  json.url graph_url(graph, format: :json)
end
