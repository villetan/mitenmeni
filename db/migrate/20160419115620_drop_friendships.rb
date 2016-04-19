class DropFriendships < ActiveRecord::Migration
  def change
    execute "DROP TABLE friendships"
  end
end
