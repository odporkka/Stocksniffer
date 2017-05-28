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
      @filepath = Rails.root+"tmp/xetra_test.csv"
      @org_csv_filepath = Rails.root+"tmp/xetra_test_org.csv"
      File.write(Rails.root+"tmp/xetra_test_org.csv", test_xetra_csv)
      allow(CsvReader).to receive(:xetra_file).and_return(@filepath)
      allow(CsvReader).to receive(:xetra_all_instruments).and_return(@org_csv_filepath)
    end
    after (:each) do
      File.delete(Rails.root+"tmp/xetra_test.csv")
      File.delete(Rails.root+"tmp/xetra_test_org.csv")
    end

    it "Should edit original file correctly" do
      CsvReader.edit_xetra_all_instruments_file
      first_line = File.open(@filepath, &:readline)
      expect(first_line).
          to eq("Instrument,ISIN,Mnemonic"+
                    "\n")
    end

    it "Should parse headers correctly" do
      CsvReader.edit_xetra_all_instruments_file
      CsvReader.parse_headers(@filepath, CsvReader.xetra_headers)
      first_line = File.open(@filepath, &:readline)
      expect(first_line).
          to eq("name,isin,symbol"+
             "\n")
    end

    it "Should import instruments correctly with no duplicates" do
      CsvReader.read_xetra_instruments
      expect(XetraInstrument.count).to eq (3)
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
  'Date Last Update:
XETR, XBUL, XCAY, XEUB, XMAL, XAFX (Xetra): 25.05.2017
XFRA (Bˆrse Frankfurt): 25.05.2017
XDUB (Dublin): 25.05.2017
Date Last Update;Instrument;ISIN;ISIX;WKN;Mnemonic;MIC Code;CCP eligible;Instrument Group Description;Instrument Group;Trading Model Type;Designated Sponsor;Market Expert;Maximum Spread;Minimum Quote Size;Maximum Surplus;Round Lot;Min Tradable Unit;Start Pre Trading;End Post Trading;Start Opening Auction;Start Intraday Auction;Start Intraday Auction 2;Start Intraday Auction 3;Start Intraday Auction 4;Start Intraday Auction 5;Start Intraday Auction 6;Start Intraday Auction 7;Start Intraday Auction 8;Start Intraday Auction 9;Start Intraday Auction 10;Start Closing Auction;Start Continuous Auction;End Continuous Auction;Set ID;Instrument Type;Instrument Sub Type;Tick Size 1;Upper Price Limit Max;Tick Size 2;Upper Price Limit 2;Tick Size 3;Upper Price Limit 3;Tick Size 4;Upper Price Limit 4;Tick Size 5;Upper Price Limit 5;Tick Size 6;Upper Price Limit 6;Tick Size 7;Upper Price Limit 7;Tick Size 8;Upper Price Limit 8;Tick Size 9;Upper Price Limit 9;Tick Size 10;Upper Price Limit 10;Tick Size 11;Upper Price Limit 11;Tick Size 12;Upper Price Limit 12;Tick Size 13;Upper Price Limit 13;Tick Size 14;Upper Price Limit 14;Tick Size 15;Upper Price Limit 15;Tick Size 16;Upper Price Limit 16;Tick Size 17;Upper Price Limit 17;Tick Size 18;Upper Price Limit 18;Tick Size 19;Upper Price Limit 19;Tick Size 20;Upper Price Limit 20;Number of Decimal Digits;Unit of Quotation;Interest Rate;Bond Yield Trading Indicator;Settlement Period;Closing Price Previous Business Day;Market Segment;Market Segment Supplement;Clearing Location;Specialist;Specialist Subgroup;Primary Market MIC Code;Minimum Hidden Order Value;Optimal Gateway Location ;Flat Indicator;Reference Market;Reporting Market;In Subscription;Trading Calendar;Settlement Calendar;Exchange Segment Code; Settlement Currency; Closed Book Indicator; Market Imbalance Indicator;Quote Book Indicator; EnBS Port; EnBS Market Depth; EnBS Snapshot Address A; EnBS Delta Address A;EnBS ATP Address A;EnBS Snapshot Address B;EnBS Delta Address B;EnBS ATP Address B;MDI Port;MDI Market Depth;MDI Inside Market Address A;MDI Inside Market Address B;Min Ord Size;Single Auction Indicator;Special Auction Indicator;Market Maker Protection Indicator;CUM/EX Indicator;Mini Auction Indicator;Liquidity Interruption Indicator;Self Match Prevention Indicator;Volume Discovery Min Execution Quantity
25.05.2017;DP WORLD LTD    DL 2;AEDFXA0M6V00;00732151;000A0M6V0;3DW;XFRA;no;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0003;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;19.5;Xetra Frankfurt 2 - Open Market;;BOFRA;BAADER BANK AG;VRA;DIFX;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;ADES INTL HLDG LTD  VE 1;AEDFXA1EN018;01612066;000A2DRV4;9HA;XFRA;no;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0067;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;14.064;Xetra Frankfurt 2 - Open Market;;BOFRA;ICF BANK AG WERTPAPIERHANDELSBANK;VR4;XLON;0.000;0000;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;Y;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;SINOVAC BIOTECH   DL-,001;AGP8696W1045;00684973;000789125;SVQ;XFRA;no;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0009;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;4.069;Xetra Frankfurt 2 - Open Market;;BOFRA;TRADEGATE AG WERTPAPIERHANDELSBANK;VR1;XNAS;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;SCHLUMBERGER   DL-,01;AN8068571086;00000217;000853390;SCL;XETR;no;SUEDAMERIKA MITTELAMERIKA;SAM0;CONTINUOUS TRADING;BANKHAUS MAX FLESSA KG#;;2.5 %;400.000;8000.000;1.000;1.000;07:30;20:31;08:50;13:15;;;;;;;;;;17:30;;;0205;Equity;;0.05;999,999.999;0.01;100.0;0.005;50.0;0.001;10.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;64.41;Open Market;;BOFRA;;;XNYS;0.000;0000;0;XETR;XETB;N;TFFM;SFFM;;EUR;Y;Y;N;55100;10;224.000.046.022;224.000.046.024;224.000.046.023;224.000.047.022;224.000.047.024;224.000.047.023;55100;05;224.000.048.007;224.000.049.007;1.000;N;N;N;;N;N;Y;777.000
25.05.2017;SCHLUMBERGER   DL-,01;AN8068571086;00000217;000853390;SCL;XETR;no;SUEDAMERIKA MITTELAMERIKA;SAM0;CONTINUOUS TRADING;BANKHAUS MAX FLESSA KG#;;2.5 %;400.000;8000.000;1.000;1.000;07:30;20:31;08:50;13:15;;;;;;;;;;17:30;;;0205;Equity;;0.05;999,999.999;0.01;100.0;0.005;50.0;0.001;10.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;64.41;Open Market;;BOFRA;;;XNYS;0.000;0000;0;XETR;XETB;N;TFFM;SFFM;;EUR;Y;Y;N;55100;10;224.000.046.022;224.000.046.024;224.000.046.023;224.000.047.022;224.000.047.024;224.000.047.023;55100;05;224.000.048.007;224.000.049.007;1.000;N;N;N;;N;N;Y;777.000
25.05.2017;SCHLUMBERGER   DL-,01;AN8068571086;00684971;000853390;SCL;XFRA;no;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0005;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;64.45;Xetra Frankfurt 2 - Open Market;;BOFRA;BAADER BANK AG;VRA;XNYS;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;HUNTER DOUGLAS      EO-24;ANN4327C1220;00684970;000855243;HUD;XFRA;no;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0003;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;73.595;Xetra Frankfurt 2 - Open Market;;BOFRA;BAADER BANK AG;VRA;XAMS;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;ORTHOFIX INT.      DL-,10;ANN6748L1027;00684969;000889410;OFX;XFRA;no;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0004;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;37.763;Xetra Frankfurt 2 - Open Market;;BOFRA;BAADER BANK AG;VRA;XNAS;0.000;0000;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;SAPIENS INTL NV    DL-,01;ANN7716A1513;00684967;000766046;SPS1;XFRA;no;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0003;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;11.038;Xetra Frankfurt 2 - Open Market;;BOFRA;BAADER BANK AG;VRA;XNCM;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;ARGENTINA 2024;ARARGE03H413;00447972;000A1ZJDD;;XFRA;no;BONDS FFM2;BD00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;17:30;0085;Bonds;Anleihe;0.005;10,000;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;5;Percent;8.7500000;;2;118.05;Xetra Frankfurt 2 - Open Market;;BOFRA;RENELL WERTPAPIERHANDELSBANK AG;VR2;XBUE;0.000;0001;1;XFRA;FRAB;N;TFRA;SFRA;XEXB;EUR;Y;N;Y;56100;01;224.000.046.132;224.000.046.134;224.000.046.133;224.000.047.132;224.000.047.134;224.000.047.133;56100;01;224.000.048.024;224.000.049.024;1.000;N;N;N;;N;N;N;0.000
25.05.2017;BBVA BCO FR.         AP 1;ARP125991090;00684965;000892998;BDPA;XFRA;no;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0001;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;4.456;Xetra Frankfurt 2 - Open Market;;BOFRA;BAADER BANK AG;VRA;XBUE;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;STRABAG SE;AT000000STR1;00684964;000A0M23V;XD4;XFRA;yes;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0009;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;37.69;Xetra Frankfurt 2 - Open Market;;BOCCP;TRADEGATE AG WERTPAPIERHANDELSBANK;VR1;XWBO;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;AMAG AUSTRIA METALL INH.;AT00000AMAG3;00002925;000A1JFYU;AM8;XETR;yes;OESTERREICH;AST0;CONTINUOUS TRADING;RAIFFEISEN CENTROBANK AG#;;5.0 %;300.000;6000.000;1.000;1.000;07:30;20:31;08:50;13:15;;;;;;;;;;17:30;;;0202;Equity;;0.05;999,999.999;0.01;100.0;0.005;50.0;0.001;10.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;44.07;Open Market;;BOCCP;;;XWBO;0.000;0001;0;XETR;XETB;N;TFFM;SFFM;;EUR;Y;Y;N;55100;20;224.000.046.014;224.000.046.016;224.000.046.015;224.000.047.014;224.000.047.016;224.000.047.015;55100;05;224.000.048.005;224.000.049.005;1.000;N;N;N;;N;N;Y;1138.000
25.05.2017;AMAG AUSTRIA METALL INH.;AT00000AMAG3;00684963;000A1JFYU;AM8;XFRA;yes;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0006;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;44.072;Xetra Frankfurt 2 - Open Market;;BOCCP;BAADER BANK AG;VRA;XWBO;0.000;0000;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;N;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;FACC AG INH.AKT.;AT00000FACC2;00002974;000A1147K;1FC;XETR;yes;OESTERREICH;AST0;CONTINUOUS TRADING;RAIFFEISEN CENTROBANK AG#;;0.32;2000.000;40000.000;1.000;1.000;07:30;20:31;08:50;13:15;;;;;;;;;;17:30;;;0204;Equity;;0.05;999,999.999;0.01;100.0;0.005;50.0;0.001;10.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;6.965;Open Market;;BOCCP;;;XWBO;0.000;0000;0;XETR;XETB;N;TFFM;SFFM;;EUR;Y;Y;N;55100;20;224.000.046.014;224.000.046.016;224.000.046.015;224.000.047.014;224.000.047.016;224.000.047.015;55100;05;224.000.048.005;224.000.049.005;1.000;N;N;N;;N;N;Y;7179.000
25.05.2017;FACC AG INH.AKT.;AT00000FACC2;00907356;000A1147K;1FC;XFRA;yes;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0005;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;7.077;Xetra Frankfurt 2 - Open Market;;BOCCP;BAADER BANK AG;VRA;XWBO;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;Y;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;FLUGHAFEN WIEN AG;AT00000VIE62;00382211;000A2AMK9;FLW1;XFRA;yes;EQUITIES FFM2;EQ00;CONTINUOUS AUCTION;;;0.0 %;0.000;1.000;1.000;1.000;07:00;20:30;;;;;;;;;;;;;08:00;20:00;0065;Equity;;0.001;999,999.999;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;3;Number of Shares;;;2;33.03;Xetra Frankfurt 2 - Open Market;;BOCCP;ICF BANK AG WERTPAPIERHANDELSBANK;VR4;XWBO;0.000;0000;0;XFRA;FRAB;N;TFRA;SFRA;XEXE;EUR;Y;Y;Y;56100;01;224.000.046.129;224.000.046.131;224.000.046.130;224.000.047.129;224.000.047.131;224.000.047.130;56100;01;224.000.048.023;224.000.049.023;1.000;N;N;N;;N;N;N;0.000
25.05.2017;ERSTE GP BNK AG  97-27 4;AT0000272505;00684930;000356831;;XFRA;no;BONDS FFM2;BD00;CONTINUOUS AUCTION;;;0.0 %;0.000;10000.000;10000.000;10000.000;07:00;20:30;;;;;;;;;;;;;08:00;17:30;0085;Bonds;Anleihe;0.01;10,000;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;5;Percent;6.6250000;;2;143.24;Xetra Frankfurt 2 - Open Market;;BOFRA;RENELL WERTPAPIERHANDELSBANK AG;VR2;XWBO;0.000;0001;0;XFRA;FRAB;N;TFRA;SFRA;XEXB;EUR;Y;N;Y;56100;01;224.000.046.132;224.000.046.134;224.000.046.133;224.000.047.132;224.000.047.134;224.000.047.133;56100;01;224.000.048.024;224.000.049.024;10000.000;N;N;N;;N;N;N;0.000
25.05.2017;STEIERMARK L.H. 03-43 4;AT0000325568;00185925;000A0BBXT;;XFRA;no;BONDS FFM2;BD00;CONTINUOUS AUCTION;;;0.0 %;0.000;100000.000;100000.000;100000.000;07:00;20:30;;;;;;;;;;;;;08:00;17:30;0108;Bonds;Variable Coupon Bond;0.001;10,000;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;5;Percent;0.0290000;;2;76;Xetra Frankfurt 2 - Open Market;;BOFRA;WOLFGANG STEUBING AG;VR1;XWBO;0.000;0000;0;XFRA;FRAB;N;TFRA;SFRA;XEXB;EUR;Y;N;Y;56100;01;224.000.046.132;224.000.046.134;224.000.046.133;224.000.047.132;224.000.047.134;224.000.047.133;56100;01;224.000.048.024;224.000.049.024;100000.000;N;N;N;;N;N;N;0.000
25.05.2017;RAGB 15.07.2027 6,25%;AT0000383864;00008304;000193811;OETN;XEUB;yes;EB - EUROPEAN GOVERNMENT BONDS;EGOV;CONTINUOUS TRADING;;;3.0;1000000.000;1000000.000;1000000.000;1000000.000;07:25;19:00;08:29;;;;;;;;;;;17:30;;;0301;Bonds;Anleihe;0.001;10,000;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;5;Percent;6.2500000;;2;156.5;Eurex Bonds;;ICY2K;;;XWBO;0.000;0001;0;XEUB;XEUB;N;TEUB;SEUB;;EUR;Y;N;N;55100;05;224.000.046.066;224.000.046.068;224.000.046.067;224.000.047.066;224.000.047.068;224.000.047.067;55100;05;224.000.048.056;224.000.049.056;1000000.000;N;N;N;;N;N;Y;0.000'
end