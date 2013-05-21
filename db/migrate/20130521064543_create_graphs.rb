class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :path
      t.string :gfuri

      t.timestamps
    end
  end
end
