class CreateAmenities < ActiveRecord::Migration
  def change
    execute "CREATE TABLE amenity(
      amenity_id serial PRIMARY KEY,
      name VARCHAR(200) NOT NULL,
      lat DECIMAL,
      lng DECIMAL
    );"

  end
end
