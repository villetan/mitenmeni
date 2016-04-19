require 'rails_helper'

RSpec.describe "friendships/new", type: :view do
  before(:each) do
    assign(:friendship, Friendship.new(
      :friend_a_id => 1,
      :friend_b_id => 1,
      :status => "MyString"
    ))
  end

  it "renders new friendship form" do
    render

    assert_select "form[action=?][method=?]", friendships_path, "post" do

      assert_select "input#friendship_friend_a_id[name=?]", "friendship[friend_a_id]"

      assert_select "input#friendship_friend_b_id[name=?]", "friendship[friend_b_id]"

      assert_select "input#friendship_status[name=?]", "friendship[status]"
    end
  end
end
