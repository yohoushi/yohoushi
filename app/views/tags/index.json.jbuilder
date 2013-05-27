json.array!(@tags) do |tag|
  json.extract! tag, :tag
  json.url tag_url(tag, format: :json)
end
