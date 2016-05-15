require 'rails_helper'

describe "Frontpage" do
  it "has signin and rate buttons" do

    visit root_path

    click_link("signin_button")


    expect(page).to have_content("Sign in")

    visit root_path

    click_link("Start rating places!")
    expect(page).to have_content("Search places")
  end


end