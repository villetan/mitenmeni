class Rating < ActiveRecord::Base
  self.table_name="ratings"

  belongs_to :user

  validates :score, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 10}


  def self.getAll
    Rating.find_by_sql(["SELECT * FROM ratings"]).to_a
  end

  def self.createNew(params)#varmaan toimii

    Rating.find_by_sql(["INSERT  INTO ratings (score, user_id) VALUES (?,?)", params[:score].to_i, params[:user_id].to_i])
  end

  def self.validate?(params)
    User.find_by_sql(["SELECT * FROM users WHERE user_id=?", params[:user_id].to_i]).to_a.length>0 and params[:score].to_i >= 0 and params[:score].to_i <= 10
  end

  def destroyRating
    Rating.find_by_sql(["DELETE FROM ratings WHERE rating_id=?", self.id])
  end


end
