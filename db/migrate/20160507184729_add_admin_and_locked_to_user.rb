class AddAdminAndLockedToUser < ActiveRecord::Migration
  def change
    execute("ALTER TABLE users ADD COLUMN admin BOOLEAN")
    execute("ALTER TABLE users ADD COLUMN locked BOOLEAN")
  end
end
