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
    mkt_cap 100.0
    shares 1.0
    close 99.9
    open 100.0
    t_pe 20.0
    f_pe 24.9
    eps 10.0
    beta 1.5
    inst_own 50.0
    high52 105.4
    low52 76.9

    range "99.00 - 101.00"
    vol_per_avg "10.00M/10.00M"
    div_per_yield "0.50/1.00"
  end
end