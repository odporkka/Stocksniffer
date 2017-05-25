FactoryGirl.define do
  factory :xetra_instrument do
    name "Test Inc."
    isin "TST-123"
    symbol "TST"
  end

  factory :nasdaq_instrument do
    name "Test Inc."
    symbol "TST"
  end
end