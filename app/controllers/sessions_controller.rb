class SessionsController < ApplicationController
  def new
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.getUserByUsername(params[:username])
    # talletetaan sessioon kirjautuneen käyttäjän id (jos käyttäjä on olemassa)
    if user && user.authenticate?(user.username,params[:password])
      session[:user_id] = user.id unless user.nil?
      # uudelleen ohjataan käyttäjä omalle sivulleen
      redirect_to user, notice: "Welcome back!"

    else
      redirect_to :back, notice: "Username and password do not match"
    end
  end

  def destroy
    # nollataan sessio
    user=current_user
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root, notice: "#{user.username} logged out."
  end
end