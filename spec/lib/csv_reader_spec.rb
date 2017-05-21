require "rails_helper"

describe "lib/ CSV Reader" do

  describe "NASDAQ" do
    before (:each) do
      @filepath = Rails.root+"tmp/nasdaq_test"
      File.write(Rails.root+"tmp/nasdaq_test", test_nasdaq_csv)
      allow(CsvReader).to receive(:nasdaq_file).and_return(@filepath)
    end
    after (:each) do
      File.delete(Rails.root+"tmp/nasdaq_test")
    end

    it "Should parse headers correctly" do
      CsvReader.parse_headers(@filepath, CsvReader.nasdaq_headers)
      first_line = File.open(@filepath, &:readline)
      expect(first_line).
          to eq("\"symbol\",\"name\",\"LastSale\",\"MarketCap\",\"IPOyear\",\"Sector\",\"industry\",\"Summary Quote\","+
             "\n")
    end

    it "Should import instruments correctly with no duplicates" do
      CsvReader.read_nasdaq_instruments
      expect(NasdaqInstrument.count).to eq (3)
      expect(NasdaqInstrument.first.name).to eq ("1347 Property Insurance Holdings, Inc.")
      expect(NasdaqInstrument.first.symbol).to eq ("PIH")
    end

  end

  describe "XETRA" do
    before (:each) do
      @filepath = Rails.root+"tmp/xetra_test"
      File.write(Rails.root+"tmp/xetra_test", test_xetra_csv)
      allow(CsvReader).to receive(:xetra_file).and_return(@filepath)
    end
    after (:each) do
      File.delete(Rails.root+"tmp/xetra_test")
    end

    it "Should parse headers correctly" do
      CsvReader.parse_headers(@filepath, CsvReader.xetra_headers)
      first_line = File.open(@filepath, &:readline)
      expect(first_line).
          to eq("name;isin;instrument_type"+
          "\n")
    end
    it "Should import instruments correctly with no duplicates" do
      CsvReader.read_xetra_instruments
      expect(XetraInstrument.count).to eq (10)
      expect(XetraInstrument.first.name).to eq ("DP WORLD LTD    DL 2")
      expect(XetraInstrument.first.isin).to eq ("AEDFXA0M6V00")
      expect(XetraInstrument.first.instrument_type).to eq("Equity")
    end
  end
end

def test_nasdaq_csv
  '"Symbol","Name","LastSale","MarketCap","IPOyear","Sector","industry","Summary Quote",
"PIH","1347 Property Insurance Holdings, Inc.","7.35","$43.78M","2014","Finance","Property-Casualty Insurers","http://www.nasdaq.com/symbol/pih",
"PIH","1347 Property Insurance Holdings, Inc.","7.35","$43.78M","2014","Finance","Property-Casualty Insurers","http://www.nasdaq.com/symbol/pih",
"TURN","180 Degree Capital Corp.","1.64","$51.04M","n/a","Finance","Finance/Investors Services","http://www.nasdaq.com/symbol/turn",
"FLWS","1-800 FLOWERS.COM, Inc.","10.4","$681.92M","1999","Consumer Services","Other Specialty Stores","http://www.nasdaq.com/symbol/flws"'
end

def test_xetra_csv
  "Instrument;ISIN;Instrument Type
DP WORLD LTD    DL 2;AEDFXA0M6V00;Equity
DP WORLD LTD    DL 2;AEDFXA0M6V00;Equity
SINOVAC BIOTECH   DL-,001;AGP8696W1045;Equity
ARGENTINA 2024;ARARGE03H413;Bonds
BBVA BCO FR.         AP 1;ARP125991090;Equity
STRABAG SE;AT000000STR1;Equity
AMAG AUSTRIA METALL INH.;AT00000AMAG3;Equity
FACC AG INH.AKT.;AT00000FACC2;Equity
FLUGHAFEN WIEN AG;AT00000VIE62;Equity
ERSTE GP BNK AG  97-27 4;AT0000272505;Bonds
STEIERMARK L.H. 03-43 4;AT0000325568;Bonds"
end