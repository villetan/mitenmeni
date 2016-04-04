class ChangeColumnNamePlaceReferenceToPlaceIdInRatings < ActiveRecord::Migration
  def change
    execute("ALTER TABLE ratings RENAME place_reference TO place_id")
  end
end
