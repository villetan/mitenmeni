require 'rails_helper'

RSpec.describe "friendships/index", type: :view do
  before(:each) do
    assign(:friendships, [
      Friendship.create!(
        :friend_a_id => 1,
        :friend_b_id => 2,
        :status => "Status"
      ),
      Friendship.create!(
        :friend_a_id => 1,
        :friend_b_id => 2,
        :status => "Status"
      )
    ])
  end

  it "renders a list of friendships" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
