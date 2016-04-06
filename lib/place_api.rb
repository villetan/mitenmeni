module PlaceApi


  @client=GooglePlaces::Client.new(ENV["GMAPS_KEY"])

  def self.get_place(place_id)
    @client.spot(place_id)
  end

  def self.key
    ENV["GMAPS_KEY"]
  end
end