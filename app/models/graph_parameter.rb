class GraphParameter < ApplicationParameter
  attr_reader :t, :from, :to, :lower_limit, :upper_limit
  alias :term :t

  SHORTABLE_TERMS = %w(c h 4h n 8h d 3d)

  Y_GRID_LIMIT_UNITS = %w(K M G T)
  Y_GRID_LIMIT_REGEXP = /\A(-?\d+)([#{Y_GRID_LIMIT_UNITS.join}]?)\Z/i

  def valid?
    self.errors.empty?
  end

  def initialize(params = {})
    update(params)
  end

  def update(params = {})
    self.errors.clear
    params = params.slice(:t, :from, :to, :size, :action, :lower_limit, :upper_limit)

    @t = params[:t].presence || @t || 'd'

    if params.has_key?(:from)
      begin
        @from = params[:from].present? ? Time.parse(params[:from]) : nil # clear if blank
      rescue ArgumentError => e
        self.errors.add(:from, 'is invalid.')
      end
    end
    if params.has_key?(:to)
      begin
        @to = params[:to].present? ? Time.parse(params[:to]) : nil # clear if blank
      rescue ArgumentError => e
        self.errors.add(:to, 'is invalid.')
      end
    end
    if @from and @to and @from >= @to
      self.errors.add(:from, 'must be older than `to`.')
    end

    @action = params[:action] || 'list_graph'
    if @action == "view_graph"
      @view_size    = params[:size].presence || @view_size || 'LL'
      @view_width   = GraphSettings.sizes[@view_size]['width']
      @view_height  = GraphSettings.sizes[@view_size]['height']
      @view_notitle = (@view_size == 'thumbnail')
    else
      @list_size    = params[:size].presence || @list_size || 'thumbnail'
      @list_width   = GraphSettings.sizes[@list_size]['width']
      @list_height  = GraphSettings.sizes[@list_size]['height']
      @list_notitle = (@list_size == 'thumbnail')
    end

    if params.has_key?(:lower_limit)
      @lower_limit = params[:lower_limit]
      if @lower_limit.present? && @lower_limit !~ Y_GRID_LIMIT_REGEXP
        self.errors.add(:lower_limit, 'is invalid.')
      end
    end
    if params.has_key?(:upper_limit)
      @upper_limit = params[:upper_limit]
      if @upper_limit.present? && @upper_limit !~ Y_GRID_LIMIT_REGEXP
        self.errors.add(:upper_limit, 'is invalid.')
      end
    end

    self
  end

  # `from` suitable for datetime picker
  def from_at
    @from.try(:strftime, '%F %T')
  end

  # `to` suitable for datetime picker
  def to_at
    @to.try(:strftime, '%F %T')
  end

  def size
    @action == "view_graph" ? @view_size : @list_size
  end

  def width
    @action == 'view_graph' ? @view_width : @list_width
  end

  def height
    @action == 'view_graph' ? @view_height : @list_height
  end

  def notitle
    @action == 'view_graph' ? @view_notitle : @list_notitle
  end

  # convert back to params
  def to_view_params
    # Without || '', query parameters become like ?t=d&size=L
    # With || '', query parameters become like ?to=&from=&t=d&size=L
    {
      't'           => @t || '',
      'from'        => @from || '',
      'to'          => @to || '',
      'size'        => @view_size || '',
      'lower_limit' => @lower_limit || '',
      'upper_limit' => @upper_limit || '',
    }
  end

  # convert back to params
  def to_list_params
    {
      't'      => @t || '',
      'from'   => @from || '',
      'to'     => @to || '',
      'size'   => @list_size || '',
      'lower_limit' => @lower_limit || '',
      'upper_limit' => @upper_limit || '',
    }
  end

  # query parameters passed to growthforecast's graph image uri
  def graph_uri_params
    params = {
      't'      => gf_term,
      'from'   => @from,
      'to'     => @to,
      'width'  => width,
      'height' => height,
      'lower_limit' => parse_limit(@lower_limit),
      'upper_limit' => parse_limit(@upper_limit),
    }
    params['notitle'] = '1' if notitle
    params
  end

  private

  def gf_term
    short_metrics = Settings.multiforecast.try(:short_metrics).nil? || Settings.multiforecast.try(:short_metrics)
    (short_metrics && SHORTABLE_TERMS.include?(@t)) ? "s#{@t}" : @t
  end

  def parse_limit(str)
    return nil unless str =~ Y_GRID_LIMIT_REGEXP
    num  = $1
    unit = $2
    if unit.present?
      case unit.downcase
      when 'k'
        num.to_i * 1_000
      when 'm'
        num.to_i * 1_000_000
      when 'g'
        num.to_i * 1_000_000_000
      when 't'
        num.to_i * 1_000_000_000_000
      end
    else
      return num.to_i
    end
  end

end
