class AddPathIndexToNodes < ActiveRecord::Migration
  def change
    add_index :nodes, :path, length: 255 # migration `20130605091736_create_nodes` was wrong
    add_index :nodes, [:type, :path], length: 255
  end
end
