require "rails_helper"

RSpec.describe XetraInstrument, type: :model do
  it "Has attributes set correctly" do
    instrument = XetraInstrument.new name: "Test Inc.", isin: "TST-123", instrument_type:"Test Instrument"
    expect(instrument.name).to eq("Test Inc.")
    expect(instrument.isin).to eq("TST-123")
    expect(instrument.instrument_type).to eq("Test Instrument")
  end

  it "Is not saved without ISIN" do
    instrument = XetraInstrument.new name: "Test Inc."
    expect(instrument).not_to be_valid
    expect(XetraInstrument.count).to eq(0)
  end

  describe "With proper attributes" do
    let!(:instrument) { FactoryGirl.create(:xetra_instrument)}

    it "is saved" do
      expect(instrument).to be_valid
      expect(XetraInstrument.count).to eq(1)
    end

    it "is not saved with same ISIN code" do
      duplicate_instrument = XetraInstrument.
          create name: "Test Inc. 2", isin: "TST-123", instrument_type:"Test Instrument 2"
      expect(duplicate_instrument).to_not be_valid
      expect(XetraInstrument.count).to eq(1)
    end
  end
end
