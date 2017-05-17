require 'rails_helper'

RSpec.describe "xetra_instruments/new", type: :view do
  before(:each) do
    assign(:xetra_instrument, XetraInstrument.new(
      :name => "MyString",
      :isin => "MyString",
      :type => ""
    ))
  end

  it "renders new xetra_instrument form" do
    render

    assert_select "form[action=?][method=?]", xetra_instruments_path, "post" do

      assert_select "input#xetra_instrument_name[name=?]", "xetra_instrument[name]"

      assert_select "input#xetra_instrument_isin[name=?]", "xetra_instrument[isin]"

      assert_select "input#xetra_instrument_type[name=?]", "xetra_instrument[type]"
    end
  end
end
