App for sniffing promising stocks from stock market.
Currently supports nasdaq stock list and xetra instrument list for importing.
Nasdq stocks use [Alpha Vantage API](http://www.alphavantage.co) for historical data.
All symbols can be searched with Google Finance scraper for more details etc.  

Goal is to expand scraping more for more in-depth analysis per stock. (And maybe between stock relations. Who knows?)

* Heroku: https://stocksniffer.herokuapp.com/
* Travis: [![Build Status](https://travis-ci.org/odporkka/stocksniffer.png)](https://travis-ci.org/odporkka/stocksniffer)
* Coveralls: [![Coverage Status](https://coveralls.io/repos/github/odporkka/stocksniffer/badge.svg?branch=master)](https://coveralls.io/github/odporkka/stocksniffer?branch=master)
* Data model: http://yuml.me/edit/c93b89ee

Ruby version 2.4.0  
Rails version 5.0.3
