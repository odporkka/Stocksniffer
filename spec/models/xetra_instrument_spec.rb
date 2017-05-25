require "rails_helper"

RSpec.describe XetraInstrument, type: :model do
  it "Has attributes set correctly" do
    instrument = XetraInstrument.new name: "Test Inc.", symbol:"TST" ,isin: "TST123"
    expect(instrument.name).to eq("Test Inc.")
    expect(instrument.symbol).to eq("TST")
    expect(instrument.isin).to eq("TST123")
  end

  it "Is not saved without symbol" do
    instrument = XetraInstrument.new name: "Test Inc.", isin: "TST123"
    expect(instrument).not_to be_valid
    expect(XetraInstrument.count).to eq(0)
  end

  describe "With proper attributes" do
    let!(:instrument) { FactoryGirl.create(:xetra_instrument)}

    it "is saved" do
      expect(instrument).to be_valid
      expect(XetraInstrument.count).to eq(1)
    end

    it "is not saved with same symbol" do
      duplicate_instrument = XetraInstrument.new name: "Test Inc. 2", symbol:"TST",isin: "TST124"
      expect(duplicate_instrument).to_not be_valid
      expect(XetraInstrument.count).to eq(1)
    end
  end
end
