class RestaurantSerializer
  attr_reader :record

  def initialize(record, options = nil)
    @record  = record
  end

  def to_hash
    {
      "id"                 => record.rid,
      "name"               => record.name,
      "address"            => record.address,
      "city"               => record.city,
      "state"              => record.state,
      "area"               => record.metro_name,
      "postal_code"        => record.postal_code,
      "country"            => record.country,
      "phone"              => record.phone,
      "lat"                => record.latitude,
      "lng"                => record.longitude,
      "price"              => record.price,
      "reserve_url"        => reserve_url,
      "mobile_reserve_url" => mobile_reserve_url,
      "image_url"          => image_url
    }
  end

  private

  def reserve_url
    "http://www.opentable.com/single.aspx?rid=#{record.rid}"
  end

  def mobile_reserve_url
    "http://mobile.opentable.com/opentable/?restId=#{record.rid}"
  end

  def image_url
    "https://www.opentable.com/img/restimages/#{record.rid}.jpg"
  end
end