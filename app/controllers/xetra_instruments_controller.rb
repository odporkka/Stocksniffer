require 'csv_reader'

class XetraInstrumentsController < ApplicationController
  before_action :set_xetra_instrument, only: [:show, :edit, :update, :destroy]
  before_action :set_instruments, only: [:index]

  # GET /xetra_instruments
  # GET /xetra_instruments.json
  def index
  end

  # GET /xetra_instruments/1
  # GET /xetra_instruments/1.json
  def show
  end

  # GET /xetra_instruments/new
  def new
    @xetra_instrument = XetraInstrument.new
  end

  # GET /xetra_instruments/1/edit
  def edit
  end

  # POST /xetra_instruments
  # POST /xetra_instruments.json
  def create
    @xetra_instrument = XetraInstrument.new(xetra_instrument_params)

    respond_to do |format|
      if @xetra_instrument.save
        format.html { redirect_to @xetra_instrument, notice: 'Xetra instrument was successfully created.' }
        format.json { render :show, status: :created, location: @xetra_instrument }
      else
        format.html { render :new }
        format.json { render json: @xetra_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /xetra_instruments/1
  # PATCH/PUT /xetra_instruments/1.json
  def update
    respond_to do |format|
      if @xetra_instrument.update(xetra_instrument_params)
        format.html { redirect_to @xetra_instrument, notice: 'Xetra instrument was successfully updated.' }
        format.json { render :show, status: :ok, location: @xetra_instrument }
      else
        format.html { render :edit }
        format.json { render json: @xetra_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /xetra_instruments/1
  # DELETE /xetra_instruments/1.json
  def destroy
    @xetra_instrument.destroy
    respond_to do |format|
      format.html { redirect_to xetra_instruments_url, notice: 'Xetra instrument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def readCsv
    CsvReader.read_xetra_instruments
    redirect_to xetra_instruments_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instruments
      @xetra_instruments = XetraInstrument.
          where('name like ?', "%#{params[:search]}%").
          paginate(:page => params[:page], :per_page => 50).
          order('name')
    end

    def set_xetra_instrument
      @xetra_instrument = XetraInstrument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def xetra_instrument_params
      params.require(:xetra_instrument).permit(:name, :isin, :type)
    end
end
