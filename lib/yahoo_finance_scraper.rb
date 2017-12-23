class YahooFinanceScraper

  def self.fetch(exchange, symbol)
    page = HTTParty.get self.url(exchange, symbol)
    parse_page = Nokogiri::HTML(page)

    data = {}

    title = parse_page.xpath('//title').text
    data['name'] = title.split(%r{:\s*})[1].sub('Summary for ', '').sub(' - Yahoo Finance','')
    data['symbol'] = symbol

    quote_summary = parse_page.css('div#quote-summary').css('tr')
    quote_summary.map do |row|
      key = row.css('td')[0].text
      val = row.css('td')[1].text
      data[key] = val
    end
    File.write(Rails.root+'tmp/last_yahoo_scrape.html', parse_page)
    data
  end

  private
  def self.url(exchange, symbol)
    "https://finance.yahoo.com/quote/#{symbol}?p=#{symbol}"
  end
end