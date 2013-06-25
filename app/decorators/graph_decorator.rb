class GraphDecorator < NodeDecorator
  delegate_all

  attr_accessor :term
  attr_accessor :from
  attr_accessor :to
  attr_accessor :size
  attr_accessor :width
  attr_accessor :height

  def validate
    self.errors.add(:from, 'must be older than `to`.') if @from and @to and @from >= @to
    self
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
