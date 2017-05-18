json.extract! nasdaq_instrument, :id, :name, :current_price, :abb, :created_at, :updated_at
json.url nasdaq_instrument_url(nasdaq_instrument, format: :json)
