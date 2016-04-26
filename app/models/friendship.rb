class Friendship < ActiveRecord::Base


  def self.send_invitation(params)
    Friendship.find_by_sql(["INSERT  INTO friendships (friend_a_id, friend_b_id, status) VALUES (?,?,?)", params[:friend_a_id],params[:friend_b_id], "pending"])
  end

  def self.validate?(params)
    suunta1=Friendship.find_by_sql(["SELECT * FROM friendships
          WHERE (friend_a_id=? AND friend_b_id=?)
          OR friend_a_id=? AND friend_b_id=?", params[:friend_a_id],params[:friend_b_id],params[:friend_b_id],params[:friend_a_id]]).to_a

     if suunta1.size.equal? 0 and params[:friend_a_id]!=params[:friend_b_id]
       return true

     end
    false
  end

  def self.get_pending_requests(current_user)
    Friendship.find_by_sql(["SELECT * FROM friendships WHERE friend_b_id=? AND status='pending'",current_user.id])
  end

  def accept_request
    a=self.friend_a_id
    b=self.friend_b_id

    Friendship.find_by_sql(["UPDATE friendships SET status='friend' WHERE friend_a_id=? AND friend_b_id=?", a,b])
    Friendship.find_by_sql(["INSERT  INTO friendships (friend_a_id, friend_b_id, status) VALUES (?,?,?)",b,a, "friend"])
  end

  def self.delete(friend_a_id, friend_b_id)
    Friendship.find_by_sql(["DELETE FROM friendships where friend_a_id=? AND friend_b_id=?", friend_a_id, friend_b_id])
    Friendship.find_by_sql(["DELETE FROM friendships where friend_a_id=? AND friend_b_id=?", friend_b_id, friend_a_id])

  end






end
