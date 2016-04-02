class User < ActiveRecord::Base
  self.table_name="users"

  validates :username, uniqueness: true, length: {minimum: 3}
  #has_secure_password


  def self.getAll
    User.find_by_sql("SELECT * FROM users")
  end


  def self.createNew(params, password_encrypted, password_salt)

    User.find_by_sql(["INSERT INTO users (username, password_encrypted, password_salt) VALUES(?,?,?)", params[:username], password_encrypted, password_salt]).to_a
  end

  def self.validate?(params)
    params["username"] and params["username"].length>3  and params["password"]==params["password_confirmation"]

  end

  def self.getUser(id)
    User.find_by_sql(["SELECT * FROM users WHERE user_id=(?)", id]).first
  end

  def self.getUserByUsername(username)
    User.find_by_sql(["SELECT * FROM users WHERE username=(?)", username]).first
  end


  def destroyUser
    User.find_by_sql(["DELETE FROM users WHERE user_id=?", self.id])
  end

  def updateUser(params)
    User.find_by_sql(["UPDATE users SET username=? WHERE user_id=?", params[:username], self.id])
  end

  def getRatings
    Rating.find_by_sql(["SELECT * FROM ratings WHERE user_id=?", self.id]).to_a
  end

  def authenticate?(username,password)
    user=User.getUserByUsername(username)
    user and user.password_encrypted == BCrypt::Engine.hash_secret(password, user.password_salt)
  end

end
