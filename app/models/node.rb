class Node < ActiveRecord::Base
  has_ancestry cache_depth: true
  scope :without_roots, lambda { where.not(ancestry: nil) }

  def graph?
    type == "Graph"
  end
  alias :leaf? :graph?

  def section?
    type == "Section"
  end
  alias :inner? :section?

  def dirname
    root? ? '' : File.dirname(path)
  end

  def basename
    root? ? 'Home' : File.basename(path)
  end

  # Create ancestors
  #
  # @param path [String] create ancestors of this path
  # @param mark [Boolean] mark touched nodes
  # @return [Integer] id of the direct parent
  def self.create_ancestors(path, mark = nil)
    if (dirname = File.dirname(path)) == '.'
      parent = Section.select(:id).roots.first || Section.create(:path => '', :mark => mark, :parent_id => nil)
    else
      parent_id = create_ancestors(dirname, mark)
      # NOTE: where(:path, :parent_id).first_or_create can not be used since :parent_id is not a real column
      parent = Section.select(:id).where(:path => dirname).first || Section.create(:path => dirname, :mark => mark, :parent_id => parent_id)
    end
    parent.id
  end

  # Find or create a node with its ancestors
  #
  # @param params [Array] parameters of the node
  # @return [Node] node object
  def self.find_or_create(params)
    node = self.where(path: params[:path]).first
    return node if node
    parent_id = self.create_ancestors(params[:path], params[:mark])
    node = self.create(params.merge(parent_id: parent_id))
  end

  # Unmark all nodes (Restore for next mark and sweep)
  def self.unmark_all
    # bulk update (only MySQL) in each 1000 records
    Node.select(:id, :path, :mark).find_in_batches(:batch_size => 1000) do |nodes|
      columns = [:id, :path, :mark]
      values  = nodes.map {|n| [n.id, n.path, nil] } # unmark
      Node.import columns, values, :on_duplicate_key_update => [:mark], :timestamps => false
    end
  end
end
