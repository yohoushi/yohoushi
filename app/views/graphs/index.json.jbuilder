json.array!(@graphs) do |graph|
  graph.each {|key, value| json.set!(key, value) }
end
