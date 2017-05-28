require "rails_helper"

describe "XETRA pages" do

  describe "index" do

    it "should not have any instruments before created" do
      visit xetra_instruments_path
      expect(page).to have_content("Xetra Instruments (0)")
    end

    it "allows user to load instruments from CSV" do
      # Csv reader is tested at spec/lib/csv_reader_spec.rb
      allow(CsvReader).to receive(:read_xetra_instruments)
      visit xetra_instruments_path
      click_button("Load from CSV")
      expect(page).to have_content("Xetra Instruments (0)")
    end

    describe "when there is instruments" do
      let!(:instrument1) { FactoryGirl.create(:xetra_instrument) }
      let!(:instrument2) { FactoryGirl.create(:xetra_instrument, isin: "TST-124", symbol:"TST2") }

      it "lists them" do
        visit xetra_instruments_path
        expect(page).to have_content("Xetra Instruments (2)")
        expect(page).to have_content("Test Inc.")
        expect(page).to have_content("TST")
        expect(page).to have_content("TST2")
      end

      it "allows user to navigate to instrument page" do
        visit xetra_instruments_path
        first(:link, "Test Inc.").click
        expect(page).to have_content("Test Inc.")
        expect(page).to have_content("Symbol: TST")
        expect(page).to have_content("ISIN: TST-123")
      end

      it "lets user search instruments" do
        FactoryGirl.create(:xetra_instrument, name: "Search Inc.", symbol: "SRCH")
        visit xetra_instruments_path
        fill_in("search", with: "Search")
        click_button("Search")
        expect(page).to have_content("Search Inc.")
        expect(page).to_not have_content("Test Inc.")
      end

      it "lets user delete instruments", :js => true do
        visit xetra_instruments_path
        accept_alert do
          first(:link, "Destroy").click
        end
        expect(page).to have_content("was successfully destroyed")
      end

      it "should paginate instrument list if there is more than 50" do
        XetraInstrument.delete_all
        i = 1
        while i <= 51 do
          FactoryGirl.create(:xetra_instrument, name: "Test Inc.", symbol: "TST"+(i).to_s)
          i += 1
        end
        visit xetra_instruments_path
        expect(page).to have_content("Previous 1 2 Next")
        expect(page).to_not have_content("TST51")
      end
    end
  end

  describe "show" do
    let!(:instrument1) { FactoryGirl.create(:xetra_instrument) }

    it "should show attributes of instrument" do
      visit xetra_instrument_path(1)
      expect(page).to have_content("Test Inc.")
      expect(page).to have_content("Symbol: TST")
      expect(page).to have_content("ISIN: TST-123")
    end
  end

  describe "new" do
    before :each do
      visit new_xetra_instrument_path
    end

    it "should show page for adding new instrument" do
      expect(page).to have_content("New Xetra Instrument")
      expect(page).to have_content("Name")
      expect(page).to have_content("Symbol")
      expect(page).to have_content("Isin")
    end

    it "should allow user to add new valid instrument" do
      fill_in("xetra_instrument[name]", with: "Test Instrument Corp")
      fill_in("xetra_instrument[symbol]", with: "TIC")
      fill_in("xetra_instrument[isin]", with: "TIC123")
      click_button("Create Xetra instrument")
      expect(XetraInstrument.count).to eq(1)
    end

    it "should discard invalid instrument" do
      click_button("Create Xetra instrument")
      expect(XetraInstrument.count).to eq(0)
      expect(page).to have_content("error")
    end
  end

  describe "edit/update" do
    let!(:instrument1) { FactoryGirl.create(:xetra_instrument) }
    before :each do
      visit edit_xetra_instrument_path(instrument1)
    end

    it "should show page for editing instrument" do
      expect(page).to have_content("Editing Xetra instrument")
      expect(find_field("xetra_instrument[name]").value).to eq("Test Inc.")
      expect(find_field("xetra_instrument[symbol]").value).to eq("TST")
      expect(find_field("xetra_instrument[isin]").value).to eq("TST-123")
    end

    it "should allow user to edit valid instrument" do
      fill_in("xetra_instrument[name]", with: "Test Corp")
      fill_in("xetra_instrument[symbol]", with: "TST")
      fill_in("xetra_instrument[isin]", with: "TST-SHT")
      click_button("Update Xetra instrument")
      expect(XetraInstrument.count).to eq(1)
      expect(XetraInstrument.first.name).to eq("Test Corp")
    end

    it "should discard invalid instrument" do
      fill_in("xetra_instrument[symbol]", with: "")
      click_button("Update Xetra instrument")
      expect(XetraInstrument.count).to eq(1)
      expect(page).to have_content("error")
    end
  end
end