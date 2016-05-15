require 'rails_helper'

describe "User" do

  it "can be created with right credentials" do
    visit signup_path
    fill_in('user_username', with:"Lauri")
    fill_in('user_password', with:"Lauri1")
    fill_in('user_password_confirmation', with:"Lauri1")
    click_button("Submit")
    expect(User.count).to eq(1)
    expect(page).to have_content("Ratings by: Lauri")
  end

  it "cannot be created without right credentials" do
    create_user_pw("Ville")
    visit signup_path
    fill_in('user_username', with:"Lauri")
    fill_in('user_password', with:"Lauri2")
    fill_in('user_password_confirmation', with:"Lauri1")
    click_button("Submit")
    expect(User.count).to eq(1)
    expect(page).to have_content("Password mismatch!")

    fill_in('user_username', with:"Ville")
    fill_in('user_password', with:"Ville1")
    fill_in('user_password_confirmation', with:"Ville1")
    click_button("Submit")

    expect(User.count).to eq(1)
    expect(page).to have_content("Username taken!")
  end
end

describe "User" do
  before :each do
    user_pw
    @user=User.first
  end

  describe "who has signed up" do



    it "can signin with right credentials" do
      sign_in("Kalle","Kalle1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Ratings by: Kalle'
    end

    it "cannot sign in with wrong credentials" do
      sign_in("Kalle", "Kalle2")
      expect(page).to have_content("Username and password do not match")
    end



    it "must insert the credentials to edit his pw" do
      sign_in("Kalle","Kalle1")
      click_link('edit')
      fill_in('user_old_password', with: "Kalle1")
      fill_in('user_password', with: "Kalle3")
      fill_in('user_password_confirmation', with: "Kalle2")
      click_button('Submit')
      expect(page).to have_content("Password mismatch!")

      fill_in('user_old_password', with: "Kalle1")
      fill_in('user_password', with: "")
      fill_in('user_password_confirmation', with: "")
      click_button('Submit')
      expect(page).to have_content("Too short password!")

    end

    it "can edit his password" do
      sign_in("Kalle","Kalle1")
      click_link('edit')
      fill_in('user_old_password', with: "Kalle1")
      fill_in('user_password', with: "Kalle2")
      fill_in('user_password_confirmation', with: "Kalle2")
      click_button('Submit')
      expect(page).to have_content("User was successfully updated.")
      click_link("Sign out")
      sign_in("Kalle", "Kalle2")

      expect(page).to have_content("Ratings by: Kalle")
      expect(page).to have_content("No ratings yet!")

    end

    it "can delete his own account" do
      sign_in("Kalle","Kalle1")
      click_link('edit')
      click_link("Delete user Kalle")
      expect(page).to have_content("User was successfully destroyed.")
      expect(User.count).to eq(0)
    end



    it "can add another user as a friend that is not yet added" do
      create_user_pw("Ville")
      sign_in("Kalle","Kalle1")
      friend_request_Ville
      expect(page).to have_content("Friend request sended!")
      friend_request_Ville
      expect(page).to have_content("Ystäväpyyntö odottaa/lähetetty")
      expect(Friendship.count).to eq(1)
    end

    it "can accept a friend request and delete a friend request" do
      create_user_pw("Ville")
      sign_in("Kalle", "Kalle1")
      friend_request_Ville
      click_link("Sign out")
      sign_in("Ville", "Kalle1")
      #accept the request
      expect(page).to have_content("Pending requests")
      click_link ("person add")
      expect(page).to have_content("Friend accepted!")
      expect(Friendship.count).to eq(2)
      expect(Friendship.get_pending_requests(User.getUserByUsername("Ville")).size).to eq(0)
      expect(User.getUserByUsername("Ville").get_friends.first).to eq(User.getUserByUsername("Kalle"))
      expect(User.getUserByUsername("Kalle").get_friends.first).to eq(User.getUserByUsername("Ville"))
      expect(Friendship.all.map(&:status)).not_to include ("pending")
      #delete friendship
      click_link("clear")
      expect(Friendship.count).to eq(0)
    end




  end

#  describe "UsersController", type: :request do
#    it "cannot edit other users" do
#      create_user_pw("Ville")
#      sign_in("Ville", "Kalle1")
#      visit users_path
#      click_link("Kalle")
#      patch user_path(User.first), :params=>{:id=>User.first.id, :username=>"LOLl"}
#      save_and_open_page
#      expect(page).to have_content("You cannot edit other users!")
#    end
#  end


  describe "Admin" do

    it "can lock and unlock other users' accounts" do
      create_admin
      sign_in("Admin", "Kalle1")
      visit users_path
      click_link("Kalle")
      expect(page).to have_content("Lock Kalle's account")

      click_link("Lock Kalle's account")
      expect(page).to have_content("USER LOCKED")
      click_link("Unlock Kalle's account")
      expect(page).to have_content("Lock Kalle's account")
    end

  end


end

private

def create_user_pw(username)
  user_params={"username" =>username, "password" => "Kalle1", "password_confirmation"=>"Kalle1"}
  password_salt = BCrypt::Engine.generate_salt
  password_encrypted = BCrypt::Engine.hash_secret(user_params["password"], password_salt)
  User.createNew(user_params, password_encrypted,password_salt)
end

def user_pw
  user_params={"username" =>"Kalle", "password" => "Kalle1", "password_confirmation"=>"Kalle1"}
  password_salt = BCrypt::Engine.generate_salt
  password_encrypted = BCrypt::Engine.hash_secret(user_params["password"], password_salt)
  User.createNew(user_params, password_encrypted,password_salt)
end

def sign_in(username, pw)
  visit signin_path
  fill_in('username', with:username)
  fill_in('password', with:pw)
  click_button('Sign in')
end



def friend_request_Ville
  click_link("Users")
  click_link("Ville")
  click_link("Add Ville as a friend")
end

def create_admin
  user_params={"username" =>"Admin", "password" => "Kalle1", "password_confirmation"=>"Kalle1"}
  password_salt = BCrypt::Engine.generate_salt
  password_encrypted = BCrypt::Engine.hash_secret(user_params["password"], password_salt)
  User.createNew(user_params, password_encrypted, password_salt)
  User.all.select{|u| u.username=="Admin"}.first.update_attribute(:admin, true)

end