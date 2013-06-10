class AddAncestryToNodes < ActiveRecord::Migration
  def up
    add_column :nodes, :ancestry, :string, limit: 4096, index: true
  end
  def down
    remove_column :nodes, :ancestry
  end
end
