require "rails_helper"

describe "lib/ Alpha Vantage API", type: :request do
  before :each do
    stub_request(:get, /.*/).to_return(body: canned_answer.to_json, headers: { "Content-Type" => "text/json" })
  end

  it "Weekly data json gets parsed right" do
    stub_request(:get, /.*/).to_return(body: canned_answer.to_json, headers: { "Content-Type" => "text/json" })

    array = AlphaVantageApi.weekly_time_series("TSLA")

    expect(array.size).to eq(15)
    expect(array[0]).to eq(["2017-05-18", "313.0600"])
    expect(array[14]).to eq(["2017-02-10", "269.2300"])
  end

  it "Weekly data fetch method works right" do
    array = AlphaVantageApi.fetch_weekly("TSLA")

    expect(array.size).to eq(15)
    expect(array[0]).to eq(["2017-05-18", "313.0600"])
    expect(array[14]).to eq(["2017-02-10", "269.2300"])
  end

  it "Three month weekly method works right" do
    array = AlphaVantageApi.three_month_weekly("TSLA")

    expect(array.size).to eq(13)
    expect(array[0]).to eq(["2017-05-18", "313.0600"])
    expect(array[12]).to eq(["2017-02-24", "257.0000"])
  end

  it "Three month weekly percentage works right" do
    pr = AlphaVantageApi.three_month_dev_pr("symbol")

    expect(pr).to eq(21.81)
  end
end

def canned_answer
  {
      "Meta Data": {
          "1. Information": "Weekly Prices (open, high, low, close) and Volumes",
          "2. Symbol": "TSLA",
          "3. Last Refreshed": "2017-05-18",
          "4. Time Zone": "US/Eastern"
      },
      "Weekly Time Series": {
          "2017-05-18": {
              "1. open": "318.3800",
              "2. high": "320.2000",
              "3. low": "305.3100",
              "4. close": "313.0600",
              "5. volume": "24140229"
          },
          "2017-05-12": {
              "1. open": "310.9000",
              "2. high": "327.0000",
              "3. low": "305.8200",
              "4. close": "324.8100",
              "5. volume": "31300046"
          },
          "2017-05-05": {
              "1. open": "314.8800",
              "2. high": "327.6600",
              "3. low": "290.7600",
              "4. close": "308.3500",
              "5. volume": "43675062"
          },
          "2017-04-28": {
              "1. open": "309.2200",
              "2. high": "314.8000",
              "3. low": "305.8600",
              "4. close": "314.0700",
              "5. volume": "24490304"
          },
          "2017-04-21": {
              "1. open": "302.7000",
              "2. high": "309.1500",
              "3. low": "297.9000",
              "4. close": "305.6000",
              "5. volume": "21731566"
          },
          "2017-04-13": {
              "1. open": "309.1500",
              "2. high": "313.7300",
              "3. low": "295.3000",
              "4. close": "304.0000",
              "5. volume": "28724351"
          },
          "2017-04-07": {
              "1. open": "286.9000",
              "2. high": "304.8800",
              "3. low": "284.5800",
              "4. close": "302.5400",
              "5. volume": "42004313"
          },
          "2017-03-31": {
              "1. open": "260.6000",
              "2. high": "282.0000",
              "3. low": "259.7500",
              "4. close": "278.3000",
              "5. volume": "25337622"
          },
          "2017-03-24": {
              "1. open": "260.6000",
              "2. high": "264.8000",
              "3. low": "250.2400",
              "4. close": "263.1600",
              "5. volume": "23549643"
          },
          "2017-03-17": {
              "1. open": "244.8200",
              "2. high": "265.7500",
              "3. low": "242.7800",
              "4. close": "261.5000",
              "5. volume": "29581526"
          },
          "2017-03-10": {
              "1. open": "247.9100",
              "2. high": "253.8900",
              "3. low": "243.0000",
              "4. close": "243.6900",
              "5. volume": "17489184"
          },
          "2017-03-03": {
              "1. open": "248.1700",
              "2. high": "254.8500",
              "3. low": "242.0100",
              "4. close": "251.5700",
              "5. volume": "28629510"
          },
          "2017-02-24": {
              "1. open": "275.4500",
              "2. high": "283.4500",
              "3. low": "250.2000",
              "4. close": "257.0000",
              "5. volume": "37518597"
          },
          "2017-02-17": {
              "1. open": "270.7400",
              "2. high": "287.3900",
              "3. low": "264.1500",
              "4. close": "272.2300",
              "5. volume": "32657156"
          },
          "2017-02-10": {
              "1. open": "251.0000",
              "2. high": "271.1800",
              "3. low": "250.6300",
              "4. close": "269.2300",
              "5. volume": "23180267"
          }
      }
  }
end