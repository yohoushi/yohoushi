class Node < ActiveRecord::Base
  has_ancestry cache_depth: true
  scope :without_roots, lambda { where.not(ancestry: nil) }
  scope :visible, lambda { where(visible: true) }

  def graph?
    type == "Graph"
  end
  alias :is_childless? :graph? # override `ancestry` to be more efficient

  def section?
    type == "Section"
  end
  alias :has_children? :section? # override `ancestry` to be more efficient

  def has_graph_child?
    children.any? {|child| child.graph? }
  end

  def dirname
    root? ? '' : File.dirname(path)
  end

  def basename(dirname = nil)
    return 'Home' if root?
    if dirname # "a" for "a/b/c" => "b/c"
      path.index("#{dirname}/") == 0 ? path["#{dirname}/".size .. -1] : path
    else
      File.basename(path)
    end
  end

  # Create ancestors
  #
  # @param path [String] create ancestors of this path
  # @return [Integer] id of the direct parent
  def self.create_ancestors(path)
    if (dirname = File.dirname(path)) == '.' || dirname == '/'
      parent = Section.select(:id).roots.first || Section.create(:path => '', :parent_id => nil)
    else
      parent_id = create_ancestors(dirname)
      # NOTE: where(:path, :parent_id).first_or_create can not be used since :parent_id is not a real column
      parent = Section.select(:id).where(:path => dirname).first || Section.create(:path => dirname, :parent_id => parent_id)
    end
    parent.id
  end

  # Find or create a node with its ancestors
  #
  # @param params [Hash] parameters of the node
  # @return [Node] node object
  def self.find_or_create(params)
    parent_id = self.create_ancestors(params[:path])
    node = self.where(path: params[:path]).first || self.create(params.merge(parent_id: parent_id))
    node
  end

  # Destroy self, and ancestors if childless
  def destroy_ancestors
    parent = self.parent
    self.destroy
    if parent and parent.children.first.blank?
      parent.destroy_ancestors
    end
  end

end
