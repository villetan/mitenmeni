require 'rails_helper'

RSpec.describe Friendship, type: :model do

  before :each do
    @user=FactoryGirl.create(:user)
    @user2=FactoryGirl.create(:user2)
    @params={:friend_a_id=>@user.id, :friend_b_id=>@user2.id}
    Friendship.send_invitation(@params)
    @friendship=Friendship.first
end

  it "has the possibility to send request" do
    expect(Friendship.count).to eq(1)
    expect(Friendship.first.status).to eq("pending")
  end

  it "has the possibility to get pending requests" do
    expect(Friendship.get_pending_requests(@user).size).to eq(0)
    expect(Friendship.get_pending_requests(@user2).size).to eq(1)
  end

  it "has the possibility to accpet friend request" do
  @friendship.accept_request
    expect(Friendship.count).to eq(2)
    expect(Friendship.all.map(&:status)).to include("friend")
  expect(Friendship.all.map(&:status)).not_to include("pending")
  end

  it "has the possibility to destroy a friend request" do
    @friendship.accept_request
    Friendship.delete(@user.id,@user2.id)
    expect(Friendship.count).to eq(0)
  end

  it "cannot send request to already friend/requested" do
    expect(Friendship.validate?(@params)).to be false
  end





end

RSpec.describe Friendship, type: :model do
  it "has a validator" do
    @user=FactoryGirl.create(:user)
    @user2=FactoryGirl.create(:user2)
    @params={:friend_a_id=>@user.id, :friend_b_id=>@user2.id}
    expect(Friendship.validate?(@params)).to be true
  end
end
