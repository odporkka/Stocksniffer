require "rails_helper"

describe "lib/ Google Finance scraper" do
  before :each do
    stub_request(:get, /.*/).to_return(body: canned_answer, headers: { "Content-Type" => "text/html" })
  end

  it "Should scrape attributes right" do
    data = GoogleFinanceScraper.fetch("AMD")

    expect(data["name"]).to eq("Advanced Micro Devices, Inc.")
    expect(data["symbol"]).to eq("AMD")
    expect(data["exchange"]).to eq("NASDAQ")
    expect(data["Open"]).to eq("11.47")
  end

  def canned_answer
    File.read(Rails.root+"spec/resources/test_search.html")
  end
end