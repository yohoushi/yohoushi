class Graph < Node
  acts_as_taggable_on :tags

  # Find or create a graph with its ancestors
  #
  # @param [Hash] params parameters of the node
  # @return [Graph] graph object
  def self.find_or_create(params)
    super.tap do |graph|
      if Settings.graph.auto_tagging
        graph.tag_list.add params[:path].split('/')
      end
      graph.save!
    end
  end

  # Find difference between given array of paths and paths stored in DB
  #
  # @param [Array] paths Array of paths to be compared
  # @param [Integer] batch_size The batch size of a select query
  # @return [Array] Plus (array) and minus (array) differences
  def self.find_diff(paths, batch_size: 1000)
    plus  = paths
    minus = []
    self.select('id, path').find_in_batches(batch_size: batch_size) do |batches|
      batches = batches.map(&:path)
      plus   -= batches
      minus  += (batches - paths)
    end
    [plus, minus]
  end
end
