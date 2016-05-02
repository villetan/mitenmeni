require 'rails_helper'

#ei toimi?
describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(PlaceApi).to receive(:search_place).with("kumpula", "Restaurant").and_return(
        [ Place.new( name:"Oljenkorsi", place_id: 1 ) ]
    )
    visit places_path
    fill_in('city', with: 'kumpula')
    select "Restaurant", :from => "type"
    click_button "Search"
    expect(page).to have_content("Oljenkorsi")
    end
end