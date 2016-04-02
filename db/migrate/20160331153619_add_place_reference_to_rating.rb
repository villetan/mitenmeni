class AddPlaceReferenceToRating < ActiveRecord::Migration
  def change
    execute("ALTER TABLE ratings ADD COLUMN place_reference varchar(255)")
    #execute("ALTER TABLE users ADD COLUMN password_salt varchar(64)")
  end
end
