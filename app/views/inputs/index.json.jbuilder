json.array!(@inputs) do |input|
  json.extract! input, :id, :sentence
  json.url input_url(input, format: :json)
end
