require 'rails_helper'

describe "NASDAQ pages" do
  before :each do
    allow(AlphaVantageApi).to receive(:fetch_weekly)
  end

  describe "index" do

    it "should not have any instruments before created" do
      visit nasdaq_instruments_path
      expect(page).to have_content("Nasdaq Instruments (0)")
    end

    it "allows user to load instruments from CSV" do
      # Csv reader is tested at spec/lib/csv_reader_spec.rb
      allow(CsvReader).to receive(:read_nasdaq_instruments)
      visit nasdaq_instruments_path
      click_button('Load from CSV')
      expect(page).to have_content("Nasdaq Instruments (0)")
    end

    describe "when there is instruments" do
      let!(:instrument1) { FactoryGirl.create(:nasdaq_instrument) }
      let!(:instrument2) { FactoryGirl.create(:nasdaq_instrument, symbol: "TST2") }

      it "lists them" do
        visit nasdaq_instruments_path
        expect(page).to have_content("Nasdaq Instruments (2)")
        expect(page).to have_content("Test Inc.")
        expect(page).to have_content("TST")
        expect(page).to have_content("TST2")
      end

      it "allows user to navigate to instrument page" do
        visit nasdaq_instruments_path
        first(:link, "Test Inc.").click
        expect(page).to have_content("Name: Test Inc.")
        expect(page).to have_content("Symbol: TST")
      end

      it "lets user search instruments" do
        FactoryGirl.create(:nasdaq_instrument, name: "Search Inc.", symbol: "SRCH")
        visit nasdaq_instruments_path
        fill_in('search', with: 'Search')
        click_button('Search')
        expect(page).to have_content("Search Inc.")
        expect(page).to_not have_content("Test Inc.")
      end

      it "lets user delete instruments", :js => true do
        visit nasdaq_instruments_path
        accept_alert do
          first(:link, "Destroy").click
        end
        expect(page).to have_content("was successfully destroyed")
      end

      it "should paginate instrument list if there is more than 50" do
        NasdaqInstrument.delete_all
        i = 1
        while i <= 51 do
          FactoryGirl.create(:nasdaq_instrument, name: "Test Inc.", symbol: "TST"+(i).to_s)
          i += 1
        end
        visit nasdaq_instruments_path
        expect(page).to have_content("Previous 1 2 Next")
        expect(page).to_not have_content("TST51")
      end
    end
  end

  describe "show" do
    let!(:instrument1) { FactoryGirl.create(:nasdaq_instrument) }

    it "should show attributes of instrument" do
      visit nasdaq_instrument_path(1)
      expect(page).to have_content("Name: Test Inc.")
      expect(page).to have_content("Symbol: TST")
    end
  end

  describe "new" do
    before :each do
      visit new_nasdaq_instrument_path
    end

    it "should show page for adding new instrument" do
      expect(page).to have_content("New Nasdaq instrument")
      expect(page).to have_content("Name")
      expect(page).to have_content("Symbol")
    end

    it "should allow user to add new valid instrument" do
      fill_in('nasdaq_instrument[name]', with: 'Test Instrument Corp')
      fill_in('nasdaq_instrument[symbol]', with: 'TIC')
      click_button('Create Nasdaq instrument')
      expect(NasdaqInstrument.count).to eq(1)
    end

    it "should discard invalid instrument" do
      click_button('Create Nasdaq instrument')
      expect(NasdaqInstrument.count).to eq(0)
      expect(page).to have_content("error")
    end
  end

  describe "edit/update" do
    let!(:instrument1) { FactoryGirl.create(:nasdaq_instrument) }
    before :each do
      visit edit_nasdaq_instrument_path(instrument1)
    end

    it "should show page for editing instrument" do
      expect(page).to have_content("Editing Nasdaq instrument")
      expect(find_field('nasdaq_instrument[name]').value).to eq("Test Inc.")
      expect(find_field('nasdaq_instrument[symbol]').value).to eq("TST")
    end

    it "should allow user to edit valid instrument" do
      fill_in('nasdaq_instrument[name]', with: 'Test Corp')
      fill_in('nasdaq_instrument[symbol]', with: 'TSTNG')
      click_button('Update Nasdaq instrument')
      expect(NasdaqInstrument.count).to eq(1)
      expect(NasdaqInstrument.first.name).to eq("Test Corp")
    end

    it "should discard invalid instrument" do
      fill_in('nasdaq_instrument[symbol]', with: '')
      click_button('Update Nasdaq instrument')
      expect(NasdaqInstrument.count).to eq(1)
      expect(page).to have_content("error")
    end
  end
end