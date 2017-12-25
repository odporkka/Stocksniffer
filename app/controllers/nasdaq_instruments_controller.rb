require "alpha_vantage_api"
require "csv_reader"
require "yahoo_finance_scraper"

class NasdaqInstrumentsController < ApplicationController
  before_action :set_nasdaq_instrument, only: [:edit, :update, :destroy]
  before_action :set_and_update_nasdaq_instrument, only: [:show]
  before_action :set_nasdaq_instruments, only: [:index]

  # GET /nasdaq_instruments
  # GET /nasdaq_instruments.json
  def index
  end

  # GET /nasdaq_instruments/1
  # GET /nasdaq_instruments/1.json
  def show
    @weeks = AlphaVantageApi.fetch_weekly(@nasdaq_instrument.symbol)
    @threemonths = AlphaVantageApi.three_month_weekly(@nasdaq_instrument.symbol)
    @threemonthpr = AlphaVantageApi.three_month_dev_pr(@nasdaq_instrument.symbol)
  end

  # GET /nasdaq_instruments/new
  def new
    @nasdaq_instrument = NasdaqInstrument.new
  end

  # GET /nasdaq_instruments/1/edit
  def edit
  end

  # POST /nasdaq_instruments
  # POST /nasdaq_instruments.json
  def create
    @nasdaq_instrument = NasdaqInstrument.new(nasdaq_instrument_params)
    @nasdaq_instrument.finance_object = FinanceObject.create!

    respond_to do |format|
      if @nasdaq_instrument.save
        format.html { redirect_to @nasdaq_instrument, notice: "nasdaq_instrument was successfully created." }
        format.json { render :show, status: :created, location: @nasdaq_instrument }
      else
        format.html { render :new }
        format.json { render json: @nasdaq_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nasdaq_instruments/1
  # PATCH/PUT /nasdaq_instruments/1.json
  def update
    respond_to do |format|
      if @nasdaq_instrument.update(nasdaq_instrument_params)
        format.html { redirect_to @nasdaq_instrument, notice: "nasdaq_instrument was successfully updated." }
        format.json { render :show, status: :ok, location: @nasdaq_instrument }
      else
        format.html { render :edit }
        format.json { render json: @nasdaq_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nasdaq_instruments/1
  # DELETE /nasdaq_instruments/1.json
  def destroy
    @nasdaq_instrument.destroy
    respond_to do |format|
      format.html { redirect_to nasdaq_instruments_url, notice: "nasdaq_instrument was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def read_csv
    if !Delayed::Job.any?{|job| job.handler.include? 'CsvReader'}
      CsvReader.delay.read_nasdaq_instruments
    end
    redirect_to nasdaq_instruments_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_nasdaq_instruments
    @nasdaq_instruments = NasdaqInstrument.
        where("name like ?", "%#{params[:search]}%").
        paginate(:page => params[:page], :per_page => 50).
        order("name")
  end

  def set_nasdaq_instrument
    @nasdaq_instrument = NasdaqInstrument.find(params[:id])
  end

  def set_and_update_nasdaq_instrument
    @nasdaq_instrument = NasdaqInstrument.find(params[:id])
    @fo = YahooFinanceScraper.update_instrument(@nasdaq_instrument.symbol)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def nasdaq_instrument_params
    params.require(:nasdaq_instrument).permit(:name, :symbol)
  end
end
