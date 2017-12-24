class YahooFinanceScraper

  def self.fetch(symbol)
    data = self.fetch_summary(symbol)
    data = data.merge( self.fetch_statistics(symbol))
    data
  end

  def self.fetch_summary(symbol)
    page = HTTParty.get self.summary_url(symbol)
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
    File.write(Rails.root+'tmp/last_yahoo_summary_scrape.html', parse_page)
    data
  end

  def self.fetch_statistics(symbol)
    page = HTTParty.get self.statistics_url(symbol)
    parse_page = Nokogiri::HTML(page)

    section = parse_page.css("section[data-test='qsp-statistics']").css('tr')
    data = {}

    section.map do |row|
      key = row.css('td')[0].text
      val = row.css('td')[1].text
      data[key] = val
    end

    File.write(Rails.root+'tmp/last_yahoo_statistics_scrape.html', page)
    data
  end

  def self.update_instrument(symbol)
    data = fetch(symbol)
    if NasdaqInstrument.exists? symbol: data['symbol']
      instrument = NasdaqInstrument.find_by symbol: data['symbol']
      fo = instrument.finance_object
      fo.close = data['Previous Close'].to_f
      fo.one_year = data['52 Week Range']
      fo.save!
      return instrument.finance_object
    end
  end

  private
  def self.summary_url(symbol)
    "https://finance.yahoo.com/quote/#{symbol}?p=#{symbol}"
  end

  def self.statistics_url(symbol)
    "https://finance.yahoo.com/quote/#{symbol}/key-statistics?p=#{symbol}"
  end
end