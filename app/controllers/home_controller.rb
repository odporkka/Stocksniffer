require "google_finance_scraper"
require "yahoo_finance_scraper"

class HomeController < ApplicationController
  before_action :set_exchanges, only: [:index, :scrape]
  def index
  end

  def scrape
    @google_stock = GoogleFinanceScraper.fetch(params[:exchange], params[:search])
    @yahoo_stock = YahooFinanceScraper.fetch(params[:exchange], params[:search])

    render :index
  end

  private
  def set_exchanges
    @exchanges = {"NASDAQ"=>"NASDAQ", "XETRA"=>"ETR"}
  end
end