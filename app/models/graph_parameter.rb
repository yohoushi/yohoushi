class GraphParameter < ApplicationParameter
  attr_reader :t, :from, :to, :size, :width, :height
  alias :term :t

  def initialize(params)
    params  = params.slice(:t, :from, :to, :size)
    @t      = params[:t].presence || 'd'
    begin
      @from = params[:from].present? ? Time.parse(params[:from]) : nil
    rescue ArgumentError => e
      self.errors.add(:from, 'is invalid.')
    end
    begin
      @to = params[:to].present?   ? Time.parse(params[:to])   : nil
    rescue ArgumentError => e
      self.errors.add(:to, 'is invalid.')
    end
    @size   = params[:size].presence || 'M'
    @width  = Settings.graph.sizes[@size]['width']
    @height = Settings.graph.sizes[@size]['height']
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
    {
      't'      => @t,
      'from'   => @from,
      'to'     => @to,
      'width'  => @width,
      'height' => @height,
    }
  end

  def validate
    self.errors.add(:from, 'must be older than `to`.') if @from and @to and @from >= @to
    self
  end
end
