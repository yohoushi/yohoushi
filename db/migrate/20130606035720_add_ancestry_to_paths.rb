class AddAncestryToPaths < ActiveRecord::Migration
  def up
    add_column :paths, :ancestry, :string, limit: 4096, index: true
  end
  def down
    remove_column :paths, :ancestry
  end
end
