class User < ActiveRecord::Base


  validates :username, uniqueness: true, length: {minimum: 3}


  def self.getAll
    User.find_by_sql("SELECT * FROM users")
  end

  def self.createNew(username)
    User.find_by_sql(["INSERT INTO users (username) VALUES(?)", username]).to_a
  end

  def self.validate?(params)
    params["username"].length>3 unless params["username"].nil?

  end

  def self.getUser(id)
    User.find_by_sql(["SELECT * FROM users WHERE user_id=(?)", id]).first
  end


  def destroyUser
    User.find_by_sql(["DELETE FROM users WHERE user_id=?", self.id])
  end

  def updateUser(params)
    User.find_by_sql(["UPDATE users SET username=? WHERE user_id=?", params[:username], self.id])
  end

end
