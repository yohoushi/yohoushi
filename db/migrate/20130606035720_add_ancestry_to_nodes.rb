class AddAncestryToNodes < ActiveRecord::Migration
  def up
    add_column :nodes, :ancestry, :string, limit: 255, index: true
    add_column :nodes, :ancestry_depth, :integer, :default => 0
  end
  def down
    remove_column :nodes, :ancestry
  end
end
