class FrontpageController < ApplicationController
  def index
    @lol = Geocoder.search("128.214.138.171").first.data["loc"]

  end





end