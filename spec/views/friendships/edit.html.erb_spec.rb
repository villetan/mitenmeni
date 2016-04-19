require 'rails_helper'

RSpec.describe "friendships/edit", type: :view do
  before(:each) do
    @friendship = assign(:friendship, Friendship.create!(
      :friend_a_id => 1,
      :friend_b_id => 1,
      :status => "MyString"
    ))
  end

  it "renders the edit friendship form" do
    render

    assert_select "form[action=?][method=?]", friendship_path(@friendship), "post" do

      assert_select "input#friendship_friend_a_id[name=?]", "friendship[friend_a_id]"

      assert_select "input#friendship_friend_b_id[name=?]", "friendship[friend_b_id]"

      assert_select "input#friendship_status[name=?]", "friendship[status]"
    end
  end
end
