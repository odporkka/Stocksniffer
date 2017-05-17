require 'rails_helper'

RSpec.describe "xetra_instruments/show", type: :view do
  before(:each) do
    @xetra_instrument = assign(:xetra_instrument, XetraInstrument.create!(
      :name => "Name",
      :isin => "Isin",
      :type => "Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Isin/)
    expect(rendered).to match(/Type/)
  end
end
