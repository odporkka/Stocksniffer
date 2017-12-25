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
      fo.open = data['Open'].to_f
      fo.t_pe = data['Trailing P/E ']
      fo.f_pe = data['Forward P/E 1']
      fo.eps = data['EPS (TTM)']
      fo.beta = data['Beta']
      fo.mkt_cap = self.to_millions(data['Market Cap'])
      fo.shares = self.to_millions(data['Shares Outstanding 5'])
      fo.high52 = data['52 Week High 3'].to_f
      fo.low52 = data['52 Week Low 3'].to_f
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

  def self.to_millions(mkt_cap_string)
    if (mkt_cap_string[-1]) == 'M'
      return mkt_cap_string[0..-2].to_f
    elsif (mkt_cap_string[-1]) == 'B'
      return (mkt_cap_string[0..-2].to_f) * 1000
    end
  end
end