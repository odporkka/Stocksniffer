require "rails_helper"

RSpec.describe XetraInstrumentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/xetra_instruments").to route_to("xetra_instruments#index")
    end

    it "routes to #new" do
      expect(:get => "/xetra_instruments/new").to route_to("xetra_instruments#new")
    end

    it "routes to #show" do
      expect(:get => "/xetra_instruments/1").to route_to("xetra_instruments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/xetra_instruments/1/edit").to route_to("xetra_instruments#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/xetra_instruments").to route_to("xetra_instruments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/xetra_instruments/1").to route_to("xetra_instruments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/xetra_instruments/1").to route_to("xetra_instruments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/xetra_instruments/1").to route_to("xetra_instruments#destroy", :id => "1")
    end

  end
end
