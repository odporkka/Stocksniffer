require 'rails_helper'

RSpec.describe "XetraInstruments", type: :request do
  describe "GET /xetra_instruments" do
    it "works! (now write some real specs)" do
      get xetra_instruments_path
      expect(response).to have_http_status(200)
    end
  end
end
