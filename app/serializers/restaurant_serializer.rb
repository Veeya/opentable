class RestaurantSerializer
  attr_reader :record

  def initialize(record, options = nil)
    @record  = record
  end

  def to_hash
    {
      "id"                     => record.rid,
      "name"                   => record.name,
      "address"                => record.address,
      "address2"               => record.address2,
      "city"                   => record.city,
      "state"                  => record.state,
      "postal_code"            => record.postal_code,
      "area"                   => record.metro_name,
      "country"                => record.country,
      "phone"                  => record.phone,
      "lat"                    => record.latitude,
      "lng"                    => record.longitude,
      "price_quartile"         => record.price_quartile,
      "reservation_url"        => reservation_url,
      "profile_url"            => profile_url,
      "is_restaurant_in_group" => is_restaurant_in_group,
      "aggregate_score"        => aggregate_score,
      "review_count"           => review_count,
      "image_url"              => image_url
    }
  end

  private

  def image_url
    "https://www.opentable.com/img/restimages/#{record.rid}.jpg"
  end
end