require 'rails_helper'

RSpec.describe User, type: :model do


  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end


  it "is not saved without a password" do
    user = User.create username:"Pekka"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end



    it "is saved with a proper password" do
      user = FactoryGirl.create(:user)
      expect(User.count).to eq(1)
    end

  it "has ratings when ones created" do
    user = FactoryGirl.create(:user)
    rating = FactoryGirl.create(:rating)
    rating.user_id=user.id
    rating.save
    expect(user.getRatings.size).to eq(1)
    expect(user.getRatings.first.place_id).to eq("asdffeqasd")
  end

  it "is not saved with too short username" do
    User.create username:"pe", password_encrypted:"kissa", password_salt:"kiss-asdasd-a"
    expect(User.count).to eq(0)
  end


  it "is not saved if same username already exists" do
   user = FactoryGirl.create(:user)
   User.create username:"Pekka", password_encrypted:"kissa", password_salt:"kiss-asdasd-a"
    expect(User.count).to eq(1)
  end

  it "has a method that fetches all Users" do
    expect(User.getAll.size).to eq(0)
    user = FactoryGirl.create(:user)
    expect(User.getAll.size).to eq(1)
    expect(User.getAll.first.username).to eq("Pekka")

  end


  it "has a method that creates new user" do
    expect(User.getAll.size).to eq(0)
    params={"username" => "Kalle"}
    pw_enc="kissa"
    pw_salt="kis-asdasdasd-a"
    user = User.createNew(params, pw_enc, pw_salt)
    expect(User.getAll.first.username).to eq("Kalle")

  end

  it "has validator method that works" do
    expect(User.getAll.size).to eq(0)
    params={"username" => "Pekka", "password" => "Kissa1", "password_confirmation" => "Kissa1" }
    expect(User.validate?(params)).to be(true)
    user=FactoryGirl.create(:user)
    expect(User.validate?(params)).to be(false)

  end

  #tarkista myöhemmin että poistaa myös ratingit?
  it "has a destroy method that works" do
    user=FactoryGirl.create(:user)
    expect(User.getAll.size).to eq(1)
    user.destroyUser
    expect(User.getAll.size).to eq(0)


  end

  it "has a update method that works" do
    user=FactoryGirl.create(:user)
    pw_enc="Apina"
    pw_salt="Ap-asdasdasd-ina"
    user.updateUser(pw_enc, pw_salt)

    expect(User.first.password_encrypted).to eq("Apina")
    expect(User.first.password_salt).to eq("Ap-asdasdasd-ina")
  end

  it "has a user getter by id and by username" do
    user=FactoryGirl.create(:user)
    expect(user.id).to eq(User.getUser(user.id).id)
    expect(user.id).to eq(User.getUserByUsername(user.username).id)
  end

  it "has a authenticate method that works" do
    user_params={"username" =>"Kalle", "password" => "Kalle1", "password_confirmation"=>"Kalle1"}
    password_salt = BCrypt::Engine.generate_salt
    password_encrypted = BCrypt::Engine.hash_secret(user_params["password"], password_salt)
    User.createNew(user_params, password_encrypted,password_salt)
    user=User.first
    expect(user.authenticate?(user.username, "Kalle1")).to be(true)
    expect(user.authenticate?(user.username, "Kallaasdasde1")).to be(false)

  end

  it "has validator for edit" do

    params={"username" => "Pekka", "password" => "kissa", "password_confirmation" => "kissa"}
    password_salt = BCrypt::Engine.generate_salt
    password_encrypted = BCrypt::Engine.hash_secret("kissa", password_salt)
    User.createNew(params, password_encrypted, password_salt)
    user=User.first
    params={"username" => "Pekka", "password" => "Apina", "password_confirmation" => "Apina", "old_password"=>"kissa"}
    User.validate_edit?(params)
    expect(User.validate_edit?(params)).to be(true)
  end



end
