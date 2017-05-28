class GoogleFinanceScraper

  def self.fetch(exchange, symbol)
    page = HTTParty.get self.url(exchange, symbol)
    parse_page = Nokogiri::HTML(page)

    data = {}

    name_and_exchange = parse_page.xpath('//title').text
    data['name'] = name_and_exchange.split(%r{:\s*})[0]
    data['symbol'] = symbol
    data['exchange'] = name_and_exchange.split(%r{:\s*})[1]

    snap_data = parse_page.css('.snap-data').css('tr')
    snap_data.map do |row|
      key = row.css('.key').text.strip.gsub(/[[:space:]]/, '')
      val = row.css('.val').text.strip.gsub(/[[:space:]]/, '')
      data[key] = val
    end
    File.write(Rails.root+'tmp/last_search.html', parse_page)
    data
  end

  private
  def self.url(exchange, symbol)
    "https://www.google.com/finance?q=#{exchange}%3A#{symbol}"
  end
end