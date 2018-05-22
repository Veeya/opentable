class Restaurant
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Pagination

  field :rid, type: Integer
  field :name
  field :address
  field :address2
  field :city
  field :state
  field :postal_code
  field :metro_name
  field :country
  field :phone
  field :latitude
  field :longitude
  field :price_quartile
  field :phone_number
  field :reservation_url
  field :profile_url
  field :is_restaurant_in_group, type: Boolean
  field :aggregate_score
  field :review_count, type: Integer
  field :category, type: Array
    
  validates :rid, presence: true, uniqueness: true
  validates :name,          presence: true

  index rid: 1
  index city: 1
  index state: 1
  index postal_code: 1

  def as_json(options = {})
    RestaurantSerializer.new(self, options).to_hash
  end

  def self.unique_countries
    Restaurant.collection.distinct("country").compact.sort
  end

  def self.unique_cities
    Restaurant.collection.distinct("city").compact.sort
  end

  def self.by_id(id)
    Restaurant.where(rid: id).first
  end

  def self.import_records(results)
	Restaurant.collection.insert_many(results)
  end
end