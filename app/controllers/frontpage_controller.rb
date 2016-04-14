class FrontpageController < ApplicationController
  def index

    @lol = request.location.data["latitude"]
  end

end