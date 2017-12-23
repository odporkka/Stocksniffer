require "rails_helper"

describe "lib/ Yahoo Finance scraper" do
  before :each do
    stub_request(:get, /.*/).to_return(body: canned_answer, headers: { "Content-Type" => "text/html" })
  end

  it "Should scrape attributes right" do
    data = YahooFinanceScraper.fetch("NASDAQ","AAPL")

    expect(data["name"]).to eq("Apple Inc.")
    expect(data["symbol"]).to eq("AAPL")
    expect(data["Previous Close"]).to eq("175.01")
  end

  def canned_answer
    File.read(Rails.root+"spec/resources/yahoo_test_scrape.html")
  end
end