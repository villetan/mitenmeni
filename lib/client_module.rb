module ClientModule

  def self.client_module
    @client= GooglePlaces::Client.new(ENV["GMAPS_KEY"])
  end
end
