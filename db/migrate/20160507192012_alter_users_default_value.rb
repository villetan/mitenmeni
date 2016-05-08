class AlterUsersDefaultValue < ActiveRecord::Migration
  def change
    execute("ALTER TABLE ONLY users ALTER COLUMN locked SET DEFAULT 'FALSE'")
  end
end
