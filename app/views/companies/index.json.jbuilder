json.array!(@companies) do |company|
  json.extract! company, :id, :name, :description, :is_active
  json.url company_url(company, format: :json)
end
