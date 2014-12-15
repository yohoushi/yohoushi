class AddAncestryIndexToNodes < ActiveRecord::Migration
  def change
    add_index :nodes, [:ancestry], length: 255 # `20130606035720_add_ancestry_to_nodes.rb` was not working
    add_index :nodes, [:type, :ancestry], length: 255
  end
end
