class Rating < ActiveRecord::Base
  self.table_name="ratings"

  belongs_to :user

  validates :score, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 10}


  def self.getAll
    Rating.find_by_sql(["SELECT * FROM ratings"]).to_a
  end

  def self.createNew(params, id,place_id)
    Rating.find_by_sql(["INSERT  INTO ratings (score, user_id, place_id) VALUES (?,?,?)", params[:score].to_i, id, place_id])
  end

  def get_user
    User.find_by_sql(["SELECT * FROM users WHERE user_id=?", self.user]).to_a.first
  end

  def self.validate?(params)
    params[:score].to_i >= 0 and params[:score].to_i <= 10 and self.get_place
  end

  def destroyRating
    Rating.find_by_sql(["DELETE FROM ratings WHERE rating_id=?", self.id])
  end

  def self.get_ratings_for_restaurant(place_id)
    Rating.find_by_sql(["SELECT * FROM ratings WHERE place_id=?", place_id]).to_a
  end

  def get_place
    ClientHelper.client_module.spot(self.place_id)
  end

#paskaa!
  private
  def model_client
    GooglePlaces::Client.new(ENV["GMAPS_KEY"])
  end
end
