class GraphParameter < ApplicationParameter
  attr_reader :t, :from, :to, :size, :width, :height, :notitle
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
    params = params.slice(:t, :from, :to, :size)

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

    @size    = params[:size].presence || @size || 'M'
    @width   = GraphSettings.sizes[@size]['width']
    @height  = GraphSettings.sizes[@size]['height']
    @notitle = true if @size == 'thumbnail'

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

  # query parameters passed to growthforecast's graph image uri
  def graph_uri_params
    params = {
      't'      => gf_term,
      'from'   => @from,
      'to'     => @to,
      'width'  => @width,
      'height' => @height,
    }
    params['notitle'] = '1' if @notitle
    params
  end

  private

  def gf_term
    short_metrics = Settings.multiforecast.try(:short_metrics).nil? || Settings.multiforecast.try(:short_metrics)
    (short_metrics && SHORTABLE_TERMS.include?(@t)) ? "s#{@t}" : @t
  end
end
