class AddPasswordEncryptedAndPasswordSaltToUser < ActiveRecord::Migration
  def change
    execute("ALTER TABLE users ADD COLUMN password_salt varchar(64)")
    execute("ALTER TABLE users ADD COLUMN password_encrypted varchar(64)")
    execute("ALTER TABLE users DROP COLUMN password_digest")
  end
end
