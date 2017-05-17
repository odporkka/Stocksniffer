json.extract! xetra_instrument, :id, :name, :isin, :type, :created_at, :updated_at
json.url xetra_instrument_url(xetra_instrument, format: :json)
