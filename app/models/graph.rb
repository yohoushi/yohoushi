class Graph < Node
  acts_as_taggable_on :tags

  # Find or create a graph with its ancestors
  #
  # @param [params] parameters of the node
  # @return [Graph] graph object
  def self.find_or_create(params)
    super.tap do |graph|
      graph.tag_list.add params[:path].split('/')
      graph.save!
    end
  end
end
