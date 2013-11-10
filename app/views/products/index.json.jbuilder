json.array!(@products) do |product|
  json.extract! product, :name, :slug, :description
  json.url product_url(product, format: :json)
end
