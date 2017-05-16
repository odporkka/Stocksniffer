require 'csv'

class CsvReader

  def self.read_stocks_from_symbol_files()
    CSV.foreach(self.parse_headers(self.nasdaq_file, self.nasdaq_headers), :headers => true) do |row|
      begin
        puts row.to_hash.slice("name", "symbol")
        Stock.create!(row.to_hash.slice("name", "symbol"))
      rescue Exception => e
        puts "Error #{e}"
        next
      end
    end
  end

  private
  def self.nasdaq_headers
    {"Symbol" => "symbol",
    "Name"=>"name"}
  end

  def self.nasdaq_file
    Rails.root+"db/symbol_lists/nasdaq_list.csv"
  end

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
end