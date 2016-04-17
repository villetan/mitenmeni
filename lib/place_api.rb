module PlaceApi


  @client=GooglePlaces::Client.new(ENV["GMAPS_KEY"])

  def self.get_place(place_id)
    @client.spot(place_id)
  end

  def self.search_place(searchword, type)
    @client.spots_by_query(searchword +" suomi", :types => type, :language=>'fi' )

  end

  def self. search_by_coordinates(lat, lng, type)
    @client.spots(lat,lng, :language=>'fi', :types => type, :rank_by => :distance)
  end

  def self.key
    ENV["GMAPS_KEY"]
  end
end