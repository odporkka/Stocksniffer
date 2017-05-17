require 'rails_helper'

RSpec.describe "xetra_instruments/index", type: :view do
  before(:each) do
    assign(:xetra_instruments, [
      XetraInstrument.create!(
        :name => "Name",
        :isin => "Isin",
        :type => "Type"
      ),
      XetraInstrument.create!(
        :name => "Name",
        :isin => "Isin",
        :type => "Type"
      )
    ])
  end

  it "renders a list of xetra_instruments" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Isin".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
  end
end
