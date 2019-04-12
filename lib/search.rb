class SearchError < StandardError ; end

class Search
  FILTER_PARAMS = [
    "name", "address", "city", "state", "postal_code", "country", "phone"
  ]

  attr_reader :params
  attr_reader :name, :address, :city, :state, :postal_code, :phone
  attr_reader :page, :per_page

  def initialize(params = {})
    @params = params

    require_filters
    init_pagination
    init_filters
    validate_filters
  end

  def results
    Restaurant.where(filters).paginate(paginate_options)
  end

  private

  def require_filters
    filters = params.select do |k,v|
      FILTER_PARAMS.include?(k.to_s) && !v.to_s.blank?
    end

    if filters.size == 0
      raise SearchError, "Please provide a search parameter"
    end
  end

  def init_filters
    init_filter(:name)
    init_filter(:address)
    init_filter(:city)
    init_filter(:postal_code)
    init_filter(:phone)
  end

  def validate_filters
    if params[:state].present?
      @state = params[:state].to_s.upcase
    end

    if params[:country].present?
      @country = params[:country].to_s.upcase
    end

    if params[:postal_code].present?
      @postal_code = params[:postal_code].to_s.upcase
    end
  end

  def init_filter(field, regex = true)
    val = params[field]

    if val.present?
      val = build_regex(val) if regex
      instance_variable_set("@#{field}", val)
    end
  end

  def init_pagination
    @page     = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || 25).to_i

    unless [5, 10, 15, 25, 50, 100].include?(@per_page)
      raise SearchError, "Invalid per_page value"
    end
  end

  def paginate_options
    { page: page, limit: per_page }
  end

  def filters
    {
      name:        @name,
      address:     @address,
      city:        @city,
      state:       @state,
      postal_code: @postal_code,
      country:     @country,
      phone:       @phone
    }.select { |_,v| v.present? }
  end

  def build_regex(val)
    Regexp.new(Regexp.escape(val), Regexp::IGNORECASE)
  end
end