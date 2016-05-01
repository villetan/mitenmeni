class DropTableAmenityIfExists < ActiveRecord::Migration
  def change
    execute "DROP TABLE IF EXISTS amenity"
  end
end