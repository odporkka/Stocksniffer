require "csv"

class CsvReader

  def self.read_nasdaq_instruments
    CSV.foreach(self.parse_headers(self.nasdaq_file, self.nasdaq_headers), :headers => true) do |row|
      begin
        instrument = NasdaqInstrument.new(row.to_hash.slice("name", "symbol"))
        instrument.google_finance_object = GoogleFinanceObject.create!
        instrument.exchange = "NASDAQ"
        instrument.save!
      rescue Exception => e
        puts "Error #{e}"
        next
      end
    end
  end

  def self.read_xetra_instruments
    self.edit_xetra_all_instruments_file
    CSV.foreach(self.parse_headers(self.xetra_file, self.xetra_headers),
                :headers => true) do |row|
      begin
        instrument = XetraInstrument.new(row.to_hash.slice("name", "isin", "symbol"))
        instrument.google_finance_object = GoogleFinanceObject.create!
        instrument.exchange = "XETRA"
        instrument.save!
      rescue Exception => e
        puts "Error #{e}"
        next
      end
    end
  end

  private
  def self.parse_headers (file, headers)
    content = File.open(file) do |f|
      first_line = f.readline
      headers.each { |k,v| first_line[k] &&= v }
      first_line + f.read
    end

    File.open(file , 'w') do |f|
      f.write(content)
    end

    file
  end

  def self.nasdaq_headers
    {"Symbol" => "symbol",
    "Name"=>"name"}
  end

  def self.xetra_headers
    {"Instrument" => "name",
     "ISIN"=>"isin",
     "Mnemonic"=>"symbol"}
  end

  def self.edit_xetra_all_instruments_file
    File.delete(self.xetra_file)if  File.exist?(self.xetra_file)
    CSV.open(self.xetra_file, "w") do |csv|
      CSV.foreach(self.xetra_all_instruments,{:encoding => "iso-8859-1",
                                              :col_sep => ";",
                                              # ignore quotes
                                              :quote_char => "|"}) do |org_row|
        if org_row[6].eql?("XETR") || org_row[6].eql?("MIC Code")
          csv << [org_row[1], org_row[2], org_row[5]]
        end
      end
    end
  end

  # :nocov:
  def self.nasdaq_file
    Rails.root+"db/symbol_lists/nasdaq_list.csv"
  end

  def self.xetra_file
    Rails.root+"db/symbol_lists/xetra_instrument_list.csv"
  end

  def self.xetra_all_instruments
    Rails.root+"db/symbol_lists/allTradableInstruments.csv"
  end
  # :nocov:
end