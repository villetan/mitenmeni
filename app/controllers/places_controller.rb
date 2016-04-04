class PlacesController < ApplicationController


  def index
  end

  def search
    #@client = client
    places=client.spots_by_query(params[:city]+" suomi", :types=>['restaurant', 'bar'], :language => 'fi')
    @places=places.uniq{|p| p.place_id}
    render :index
  end

  def show
    @place=client.spot(params[:id])
    @ratings = Rating.get_ratings_for_restaurant(params[:id])
    @rating=Rating.new
  end
end
