FactoryGirl.define do
  factory :xetra_instrument do
    name "Test Inc."
    isin "TST-123"
    symbol "TST"
    finance_object
  end

  factory :nasdaq_instrument do
    name "Test Inc."
    symbol "TST"
    finance_object
  end

  factory :finance_object do
    mktcap 100.0
    shares 1.0
    open 100.0
    pe 20.0
    eps 10.0
    beta 1.5
    inst_own 50.0

    range "99.00 - 101.00"
    one_year "75.00 - 100.00"
    vol_per_avg "10.00M/10.00M"
    div_per_yield "0.50/1.00"
  end
end