class AddAncestryToPaths < ActiveRecord::Migration
  def up
    add_column :paths, :ancestry, :string, limit: 4096, inex: true, null: false
  end
  def down
    remove_column :paths, :ancestry
  end
end
