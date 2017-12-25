require "rails_helper"

describe "lib/ Yahoo Finance scraper" do
  before :each do
    stub_request(:get, "https://finance.yahoo.com/quote/AAPL?p=AAPL").to_return(body: canned_summary_answer, headers: { "Content-Type" => "text/html" })
    stub_request(:get, "https://finance.yahoo.com/quote/AAPL/key-statistics?p=AAPL").to_return(body: canned_statistic_answer, headers: { "Content-Type" => "text/html" })
  end

  it "Should scrape attributes right" do
    data = YahooFinanceScraper.fetch("AAPL")

    expect(data["name"]).to eq("Apple Inc.")
    expect(data["symbol"]).to eq("AAPL")
    expect(data["Previous Close"]).to eq("175.01")
  end

  it "Should parse big numbers to millions" do
    number = "999999.9B"
    millions = YahooFinanceScraper.send(:to_millions, number)
    expect(millions).to eq(999999900)
  end

  it "Keep millions as millions" do
    number = "999999.9M"
    millions = YahooFinanceScraper.send(:to_millions, number)
    expect(millions).to eq(999999.9)
  end

  it "Should update intrument right" do
    FactoryGirl.create(:nasdaq_instrument, name: "Apple Inc.", symbol: "AAPL")
    YahooFinanceScraper.update_instrument("AAPL")
    instrument = NasdaqInstrument.find_by symbol: "AAPL"
    expect(instrument.finance_object.close).to eq(175.01)
  end

  def canned_summary_answer
    File.read(Rails.root+"spec/resources/test_yahoo_summary_scrape.html")
  end

  def canned_statistic_answer
    File.read(Rails.root+"spec/resources/test_yahoo_statistics_scrape.html")
  end
end