FactoryGirl.define do
  factory :xetra_instrument do
    name "Test Inc."
    isin "TST-123"
    instrument_type "Equity"
  end

  factory :nasdaq_instrument do
    name "Test Inc."
    symbol "TST"
  end
end