class Place
  include ActiveModel::Model

  attr_accessor :reference, :place_id, :vicinity, :lat, :lng, :viewport, :name, :icon,
                :types, :id, :formatted_phone_number, :international_phone_number,
                :formatted_address, :address_components, :street_number, :street, :city, :region,
                :postal_code, :country, :rating, :price_level, :opening_hours, :url, :cid,
                :website, :zagat_reviewed, :Zagat_selected, :aspects, :review_summary, :photos,
                :reviews, :nextpagetoken, :events, :utc_offset



  def self.rendered_fields
    [ :name,  :types, :formatted_address]
  end

end