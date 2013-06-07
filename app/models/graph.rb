class Graph < Path
  acts_as_taggable_on :tags

  def self.find_or_create(params)
    graph = Graph.where(fullpath: params[:fullpath]).first
    unless graph
      parent_id = Graph.create_parents(params[:fullpath])
      graph = Graph.create(params.merge(parent_id: parent_id))
    end
    graph
  end
end
