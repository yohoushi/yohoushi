class GraphsTags < ActiveRecord::Migration
  def change
    create_table :graphs_tags, :id => false do |t|
      t.references :graph, :null => false
      t.references :tag, :null => false
    end

    # Adding the index can massively speed up join tables. Don't use the
    # unique if you allow duplicates.
    add_index(:graphs_tags, [:graph_id, :tag_id], :unique => true)
  end
end
