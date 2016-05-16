class User < ActiveRecord::Base
  self.table_name="users"

  validates :username, uniqueness: true, length: {minimum: 3}
  validates :password_encrypted, presence: true;
  validates :password_salt, presence: true;

  #has_secure_password


  def self.getAll
    User.find_by_sql("SELECT * FROM users")
  end


  def self.createNew(params, password_encrypted, password_salt)

    User.find_by_sql(["INSERT INTO users (username, password_encrypted, password_salt) VALUES(?,?,?)", params["username"], password_encrypted, password_salt]).to_a
  end

  def self.validate?(params)
    params["password"].length>2 and params["username"] and params["username"].length>3  and params["password"]==params["password_confirmation"] and not User.getAll.map(&:username).include? params["username"]

  end

  def self.validate_edit?(params)

    user=User.getUserByUsername(params["username"])

    params["password"].length>2 and user and params["username"] and params["username"].length>3  and params["password"]==params["password_confirmation"] and user.password_encrypted == BCrypt::Engine.hash_secret(params["old_password"], user.password_salt)

  end

  def self.getUser(id)
    User.find_by_sql(["SELECT * FROM users WHERE user_id=(?)", id]).first
  end

  def self.getUserByUsername(username)
    User.find_by_sql(["SELECT * FROM users WHERE username=(?)", username]).first
  end


  def destroyUser
    Rating.find_by_sql(["UPDATE ratings set user_id=NULL WHERE user_id=(?)", self.id])

    User.find_by_sql(["DELETE FROM users WHERE user_id=?", self.id])
  end

  def updateUser(password_encrypted, password_salt)
    User.find_by_sql(["UPDATE users SET password_encrypted=(?), password_salt=(?) WHERE user_id=(?)", password_encrypted, password_salt, self.id])
  end

  def getRatings
    Rating.find_by_sql(["SELECT * FROM ratings WHERE user_id=?", self.id]).to_a
  end

  def authenticate?(username,password)
    user=User.getUserByUsername(username)
    user and user.password_encrypted == BCrypt::Engine.hash_secret(password, user.password_salt)
  end

  def get_friends
    User.find_by_sql(["SELECT * FROM users WHERE user_id IN (
          SELECT friend_a_id FROM friendships WHERE friend_b_id=? AND status NOT LIKE 'pending')", self.id]).to_a
  end

  def freeze_account
    User.find_by_sql(["UPDATE users SET locked=NOT locked WHERE user_id=?",  self.id])
  end

end
