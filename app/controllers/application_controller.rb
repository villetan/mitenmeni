class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :client

  def current_user
    return nil if session[:user_id].nil?
    User.getUser(session[:user_id])
  end

  def client
    @client= GooglePlaces::Client.new(ENV["GMAPS_KEY"])
  end
end
