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
  end

end
