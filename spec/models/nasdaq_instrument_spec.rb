require "rails_helper"

RSpec.describe NasdaqInstrument, type: :model do
  it "Has attributes set correctly" do
    instrument = NasdaqInstrument.new name: "Test Inc.", symbol: "TST"
    expect(instrument.name).to eq("Test Inc.")
    expect(instrument.symbol).to eq("TST")
  end

  it "Is not saved without symbol" do
    instrument = NasdaqInstrument.new name: "Test Inc."
    expect(instrument).not_to be_valid
    expect(NasdaqInstrument.count).to eq(0)
  end

  describe "With proper attributes" do
    let!(:instrument) { FactoryGirl.create(:nasdaq_instrument) }

    it "is saved" do
      expect(instrument).to be_valid
      expect(NasdaqInstrument.count).to eq(1)
    end

    it "is not saved with same symbol" do
      duplicate_instrument = NasdaqInstrument.
          create name: "Test Inc. 2", symbol: "TST"
      expect(duplicate_instrument).to_not be_valid
      expect(NasdaqInstrument.count).to eq(1)
    end
  end
end
