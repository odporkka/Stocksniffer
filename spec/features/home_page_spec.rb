require 'rails_helper'

describe "Home page" do
  before :each do
    stub_request(:get, /.*/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/html" })
  end

  it "Should have title correctly" do
    visit root_path
    expect(page).to have_content 'Stocksniffer'
  end

  it "Should have navbar correctly" do
    visit root_path
    expect(page).to have_content 'Home'
    expect(page).to have_content 'NASDAQ'
    expect(page).to have_content 'XETRA'
  end

  it "Google scraper test should work" do
    visit root_path
    fill_in('search', with:'AMD')
    click_button('Search')
    expect(page).to have_content 'Advanced Micro Devices, Inc.'
  end

  def canned_answer
    File.read(Rails.root+"spec/resources/test_search.html")
  end
end