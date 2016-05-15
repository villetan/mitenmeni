require 'rails_helper'

describe "Ratings page" do
  it "should not have any before created" do
    visit ratings_path
    expect(page).to have_content('Listing Ratings')
  end
end

describe "Ratings page" do
  before :each do
    @ratings = [9, 5, 2]
    i=1
    @ratings.each do |score|
      create_rating(score, "asd"+ (score+i).to_s, i.to_s)
      i=i+1
    end


    create_user_pw("Pekka").first
    user=User.first
        Rating.last.update_attribute(:user_id, user.id)
    allow(PlaceApi).to receive(:get_place).with("1").and_return(
        ( Place.new( name:"Oljenkorsi", place_id: "1", types: ["restaurant"], formatted_address: "liibalaabakatu 1" ))
    )
    allow(PlaceApi).to receive(:get_place).with("2").and_return(
        ( Place.new( name:"Parmesan", place_id: "2", types: ["restaurant"], formatted_address: "liibalaabakatu 1" ))
    )
    allow(PlaceApi).to receive(:get_place).with("3").and_return(
        ( Place.new( name:"Hopia", place_id: "3", types: ["bakery"], formatted_address: "liibalaabakatu 1" ))
    )
    visit ratings_path

  end
  it "should shows the created ratings" do


    expect(Rating.count).to eq(3)
    expect(page).to have_content("Oljenkorsi")
    expect(page).to have_content("Hopia")
    expect(page).to have_content("Parmesan")
  end

  it "has a link to navigate to a Rating" do
    click_link("Oljenkorsi")
    expect(page).to have_content("liibalaabakatu 1")
    expect(page).to have_content("Ratings: ")
    expect(page).to have_content("ANON")
    expect(page).to have_content("Score: 9")


    visit ratings_path
    click_link("Hopia")
    expect(page).to have_content("liibalaabakatu 1")
    expect(page).to have_content("Ratings: ")
    expect(page).to have_content("Pekka")
    expect(page).to have_content("Score: 2")

  end

  it "has a button to redirect user to search" do

    click_link("add_rating_button")
    expect(page).to have_content("Search for the desired place and rate that!")
    expect(page).to have_content("Search places")
  end

  it "has a link to navigate to a rating and give Rating for it" do
    expect(Rating.count).to eq(3)
    click_link("Oljenkorsi")
    fill_in('rating_score', with:"8")
    fill_in('rating_comment', with:"PASKA")
    click_button("Create Rating")
    expect(page).to have_content("Rating was successfully created.")
    expect(Rating.count).to eq(4)

    sign_in("Pekka", "Kalle1")
    visit ratings_path
    first(:link, "Oljenkorsi").click
    fill_in('rating_score', with:"1")
    fill_in('rating_comment', with:"HYVÄ")
    click_button("Create Rating")
    expect(page).to have_content("Rating was successfully created.")
    expect(Rating.count).to eq(5)

    first(:link, "Oljenkorsi").click
    expect(page).to have_content("Score: 1")
    expect(page).to have_content("Score: 8")
    expect(page).to have_content("Score: 9")
    expect(page).to have_content("Pekka")




  end

  it "cannot create a rating with wrong parameters" do
    click_link("Oljenkorsi")
    fill_in('rating_score', with:"KKK")
    fill_in('rating_comment', with:"PASKA")
    click_button("Create Rating")
    expect(page).to have_content("Valitsit väärät parametrit")
    expect(page).to have_content("Oljenkorsi")
    expect(page).to have_content("Rate this place")

    click_button("Create Rating")
    expect(page).to have_content("Valitsit väärät parametrit")
    expect(page).to have_content("Oljenkorsi")
    expect(page).to have_content("Rate this place")

  end

  it "and User has the posibility to edit his rating" do
    sign_in("Pekka", "Kalle1")
    click_link("2")
    click_link("Edit")
    fill_in('rating_score', with:"4")
    fill_in('rating_comment', with:"Sittenkin hyvä")


    click_button("Update Rating")
    expect(page).to have_content("Rating was succesfully updated!")
    expect(Rating.all.select{|r| r.place_id=="3"}.first.comment).to eq("Sittenkin hyvä")
    expect(Rating.all.select{|r| r.place_id=="3"}.first.score).to eq(4)

  end
end


private
def create_rating(score, comment, place_id)
  Rating.create score:score, comment:comment, place_id:place_id
end

def sign_in(u,pw)
  visit signin_path
  fill_in('username', with:u)
  fill_in('password', with:pw)
  click_button('Sign in')
end

def create_user_pw(username)
  user_params={"username" =>username, "password" => "Kalle1", "password_confirmation"=>"Kalle1"}
  password_salt = BCrypt::Engine.generate_salt
  password_encrypted = BCrypt::Engine.hash_secret(user_params["password"], password_salt)
  User.createNew(user_params, password_encrypted,password_salt)
end




