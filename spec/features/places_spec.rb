require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page and one can visit its site" do
    allow(PlaceApi).to receive(:search_place).with("kumpula", "restaurant").and_return(
        [ Place.new( name:"Oljenkorsi", place_id: 1, types: ["restaurant"], formatted_address: "liibalaabakatu 1" ) ]
    )
    visit places_path
    fill_in('city', with: 'kumpula')
    select "Restaurant", :from => "type"
    click_button "Search"
    expect(page).to have_content("Oljenkorsi")

    allow(PlaceApi).to receive(:get_place).with("1").and_return(
        ( Place.new(  name:"Oljenkorsi", place_id: 1, types: ["restaurant"], formatted_address: "liibalaabakatu 1", opening_hours:{"periods"=>[{"close"=>{"day"=>1, "time"=>"1400"}, "open"=>{"day"=>1, "time"=>"0800"}}, {"close"=>{"day"=>2, "time"=>"1400"}, "open"=>{"day"=>2, "time"=>"0800"}}, {"close"=>{"day"=>3, "time"=>"1400"}, "open"=>{"day"=>3, "time"=>"0800"}}, {"close"=>{"day"=>4, "time"=>"1400"}, "open"=>{"day"=>4, "time"=>"0800"}}, {"close"=>{"day"=>5, "time"=>"1400"}, "open"=>{"day"=>5, "time"=>"0800"}}]} ) )
    )

    click_link("Oljenkorsi")
    expect(page).to have_content("Rate this place")
  end

  it "have a method for fetching place by id" do
    allow(PlaceApi).to receive(:get_place).with(1).and_return(
        ( Place.new( name:"Oljenkorsi", place_id: 1, types: ["restaurant"], formatted_address: "liibalaabakatu 1" ))
    )
    expect(PlaceApi.get_place(1).name).to eq("Oljenkorsi")
    expect(PlaceApi.get_place(1).place_id).to eq(1)
    expect(PlaceApi.get_place(1).formatted_address).to eq("liibalaabakatu 1")
    expect(PlaceApi.get_place(1).types.first).to eq("restaurant")

  end

  it "has a method for my location search", :js=> true do
    allow(PlaceApi).to receive(:search_by_coordinates).with("15","51","restaurant").and_return(
        [ Place.new( name:"Parmesan", place_id: 1, types: ["restaurant"], formatted_address: "liibalaabakatu 1" )]
    )
    allow(Geocoder).to receive(:search).with("88.192.41.150").and_return(
        [ Geocoder::Result::Base.new(data={"loc"=>"15,51"})]
    )
    visit places_path
    select "Restaurant", :from => "type"
    find("#my_place_checked", :visible=> false).click
    click_button("Search")
    expect(page).to have_content("Parmesan")

  end




end