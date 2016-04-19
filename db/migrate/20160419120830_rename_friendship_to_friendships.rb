class RenameFriendshipToFriendships < ActiveRecord::Migration
  def change
    execute "ALTER TABLE friendship RENAME TO friendships"
  end
end
