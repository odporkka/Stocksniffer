json.extract! stock, :id, :name, :current_price, :abb, :created_at, :updated_at
json.url stock_url(stock, format: :json)
