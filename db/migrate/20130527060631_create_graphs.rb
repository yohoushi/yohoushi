class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :path, limit: 2048, index: true, null: false

      t.timestamps
    end
  end
end
