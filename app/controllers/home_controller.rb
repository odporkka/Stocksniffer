require "google_finance_scraper"

class HomeController < ApplicationController
  def index
  end

  def scrape
    @stock = GoogleFinanceScraper.fetch(params[:search])
    render :index
  end
end