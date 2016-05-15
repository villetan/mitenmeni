require 'rails_helper'


RSpec.describe Rating, type: :model do

  before :each do
    @rating=FactoryGirl.create(:rating)

  end

  it "is added to the db" do
    expect(Rating.count).to eq(1)
  end

  it "has a method for getting all" do
    expect(Rating.getAll.first).to eq(@rating)
    expect(Rating.count).to eq(1)
    r2=FactoryGirl.create(:rating2)
    expect(Rating.count).to eq(2)
    expect(Rating.second).to eq(r2)

  end

  it "has sql create new -method" do
    params={:score=>5, :place_id=>"kapakka", :comment=>"gagaaaaaaaaaa"}
    Rating.createNew(params, nil)
    expect(Rating.count).to eq(2)
    user=FactoryGirl.create(:user)
    Rating.createNew(params, user.id)
    expect(Rating.last.user_id).to eq(user.id)
  end

  it "has a method for getting the corresponding user to rating" do
    expect(@rating.get_user).to be_nil
    user=FactoryGirl.create(:user)
    params={:score=>5, :place_id=>"kapakka", :comment=>"gagaaaaaaaaaa"}
    Rating.createNew(params, user.id)
    expect(Rating.last.user).to eq(user)
  end

  it "has a validator that works" do
    params={:score=>5, :place_id=>"kapakka", :comment=>"gagaaaaaaaaaa"}
    expect(Rating.validate?(params)).to eq(true)
    params={:score=>5,  :comment=>"gagaaaaaaaaaa"}
    expect(Rating.validate?(params)).to be false
    params={ :place_id=>"kapakka", :comment=>"gagaaaaaaaaaa"}
    expect(Rating.validate?(params)).to be false
    params={  :comment=>"gagaaaaaaaaaa"}
    expect(Rating.validate?(params)).to be false
    params={:score=>5, :place_id=>"kapakka"}
    expect(Rating.validate?(params)).to eq(true)
  end

  it "has a remove method that works" do
    expect(Rating.count).to eq(1)
    @rating.destroyRating
    expect(Rating.count).to eq(0)
  end

  it "has a method to fetch all ratings from spesific place" do
    expect(Rating.get_ratings_for_restaurant("asdffeqasd").size).to eq(1)
    params1={:score=>6, :place_id=>"asdffeqasd"}
    Rating.createNew(params1, nil)
    params2={:score=>1, :place_id=>"asdffeqasd"}
    Rating.createNew(params2, nil)
    expect(Rating.get_ratings_for_restaurant("asdffeqasd").size).to eq(3)
    expect(Rating.get_ratings_for_restaurant("asdffeqasd").map(&:score)).to include(9,6,1)
    expect(Rating.get_ratings_for_restaurant("asdffeqasd").map(&:score)).not_to include(10,7,2)
  end
# tee ilman kyselyä!
 it "has a method that fetches the corresponding place" do
   allow(PlaceApi).to receive(:get_place).with("ChIJZZSm4sCcKkQRQFbBSlKsnjY").and_return(
       ( Place.new( name:"Oljenkorsi", place_id: "ChIJZZSm4sCcKkQRQFbBSlKsnjY", types: ["restaurant"], formatted_address: "liibalaabakatu 1" ))
   )
   params1={:score=>6, :place_id=>"ChIJZZSm4sCcKkQRQFbBSlKsnjY"}
   Rating.createNew(params1, nil)
   expect(Rating.last.get_place.name).to eq("Oljenkorsi")
 end

  it "has a getter method for rating by id" do
    id=Rating.last.id
    expect(Rating.get_rating(id).score).to eq(9)
    expect(Rating.get_rating(id).comment).to eq("moi")
  end

  it "has a edit method" do
    params={:score=>1, :comment=>"moimoi"}
    Rating.last.update_rating(params, Rating.last.id)
    expect(Rating.validate_edit?(params)).to eq(true)
    expect(Rating.last.score).to eq(1)
    expect(Rating.last.comment).to eq("moimoi")
  end

end