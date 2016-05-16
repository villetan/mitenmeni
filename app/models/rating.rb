class Rating < ActiveRecord::Base
  self.table_name="ratings"



  belongs_to :user

  validates :score, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 10}


  def self.getAll
    Rating.find_by_sql(["SELECT * FROM ratings"]).to_a
  end

  def self.createNew(params, id)
    Rating.find_by_sql(["INSERT  INTO ratings (score, user_id, place_id, comment) VALUES (?,?,?,?)", params[:score].to_i, id, params[:place_id], params[:comment]])
  end



  def self.validate?(params )
    not params[:score].nil? and is_number?(params[:score]) and params[:score].to_i >= 0 and params[:score].to_i <= 10 and (not params[:place_id].nil?)
  end

  def self.validate_edit?(params)
    not params[:score].nil? and not params[:score]=="" and params[:score].to_i >= 0 and params[:score].to_i <= 10
  end

  def destroyRating
    Rating.find_by_sql(["DELETE FROM ratings WHERE rating_id=?", self.id])
  end

  def self.get_ratings_for_restaurant(place_id)
    Rating.find_by_sql(["SELECT * FROM ratings WHERE place_id=?", place_id]).to_a
  end

  def get_user
    User.find_by_sql(["SELECT * FROM users WHERE user_id=?", self.user_id]).to_a.first
  end


  def get_place
    PlaceApi.get_place(place_id)
  end

  def self.get_rating(id)
    Rating.find_by_sql(["SELECT * FROM ratings WHERE rating_id=?", id]).to_a.first
  end

  def update_rating(params, id)
    Rating.find_by_sql(["UPDATE ratings SET comment=(?), score=? WHERE rating_id=?", params[:comment], params[:score], id])
  end






#paskaa!
  private
  def model_client
    GooglePlaces::Client.new(ENV["GMAPS_KEY"])
  end
end


def is_number? string
  true if Float(string) rescue false
end