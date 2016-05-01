require 'rails_helper'

describe "Users page" do
  it "should not have any before created" do
    visit users_path
    expect(page).to have_content('Listing Users')
    expect(page).to have_content('No one is using this website...yet.')
  end
end
describe "Users page" do

  before :each do
    @users = ["Arto", "matti", "Coolness"]
    @users.each do |user|
      create_user_pw(user)
    end
    visit users_path

  end


  it "lists users when someone has created one and allows one to go to one user's page" do
    @users.each do |user|
      expect(page).to have_content(user)
    end

    click_link('Arto')
    expect(page).to have_content("Ratings by: Arto")
    expect(page).to have_content("No ratings yet!")
  end

end

private

def create_user_pw(username)
  user_params={"username" =>username, "password" => "Kalle1", "password_confirmation"=>"Kalle1"}
  password_salt = BCrypt::Engine.generate_salt
  password_encrypted = BCrypt::Engine.hash_secret(user_params["password"], password_salt)
  User.createNew(user_params, password_encrypted, password_salt)
end