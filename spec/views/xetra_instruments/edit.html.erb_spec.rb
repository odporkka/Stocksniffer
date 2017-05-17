require 'rails_helper'

RSpec.describe "xetra_instruments/edit", type: :view do
  before(:each) do
    @xetra_instrument = assign(:xetra_instrument, XetraInstrument.create!(
      :name => "MyString",
      :isin => "MyString",
      :type => ""
    ))
  end

  it "renders the edit xetra_instrument form" do
    render

    assert_select "form[action=?][method=?]", xetra_instrument_path(@xetra_instrument), "post" do

      assert_select "input#xetra_instrument_name[name=?]", "xetra_instrument[name]"

      assert_select "input#xetra_instrument_isin[name=?]", "xetra_instrument[isin]"

      assert_select "input#xetra_instrument_type[name=?]", "xetra_instrument[type]"
    end
  end
end
