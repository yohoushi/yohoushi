class GraphParameter
  include ActiveModel::Validations
  attr_reader :t, :from, :to, :size, :width, :height
  alias :term :t

  def initialize(params)
    params  = params.slice(:t, :from, :to, :size)
    @t      = params[:t].presence || 'd'
    @from   = params[:from].present? ? Time.parse(params[:from]) : nil
    @to     = params[:to].present?   ? Time.parse(params[:to])   : nil
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

  # Show ActiveModel::Errors on the view
  def view_errors
    self.errors.full_messages.sort{|a,b| a.downcase <=> b.downcase }.join("<br />") if errors.present?
  end
end
