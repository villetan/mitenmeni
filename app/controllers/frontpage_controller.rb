class FrontpageController < ApplicationController
  def index
    @lol = Geocoder.search("88.192.41.150").first.data["loc"]

  end





end