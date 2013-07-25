class GraphParameter < ApplicationParameter
  attr_reader :t, :from, :to
  alias :term :t

  SHORTABLE_TERMS = %w(c h 4h n 8h d 3d)

  def valid?
    self.errors.empty?
  end

  def initialize(params = {})
    update(params)
  end

  def update(params = {})
    self.errors.clear
    params = params.slice(:t, :from, :to, :size, :action)

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
      @view_notitle = true if @view_size == 'thumbnail'
    else
      @list_size    = params[:size].presence || @list_size || 'thumbnail'
      @list_width   = GraphSettings.sizes[@list_size]['width']
      @list_height  = GraphSettings.sizes[@list_size]['height']
      @list_notitle = true if @list_size == 'thumbnail'
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

  # query parameters passed to growthforecast's graph image uri
  def graph_uri_params
    params = {
      't'      => gf_term,
      'from'   => @from,
      'to'     => @to,
      'width'  => width,
      'height' => height,
    }
    params['notitle'] = '1' if notitle
    params
  end

  private

  def gf_term
    short_metrics = Settings.multiforecast.try(:short_metrics).nil? || Settings.multiforecast.try(:short_metrics)
    (short_metrics && SHORTABLE_TERMS.include?(@t)) ? "s#{@t}" : @t
  end
end
