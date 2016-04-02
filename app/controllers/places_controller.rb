class PlacesController < ApplicationController


  def index
  end

  def search
    #@client = client
    @places=client.spots_by_query(params[:city]+" finland", :types=>['restaurant', 'bar'])
    render :index
  end
end
