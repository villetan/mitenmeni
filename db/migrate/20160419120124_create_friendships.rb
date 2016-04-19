class CreateFriendships < ActiveRecord::Migration
  def change
    execute "CREATE TABLE friendship(
    friendship_id serial PRIMARY KEY,
    friend_a_id INT references users(user_id),
    friend_b_id INT references users(user_id),
    status VARCHAR(20) NOT NULL
    );"
    end
  end
