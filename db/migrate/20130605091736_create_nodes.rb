class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :type # STI
      t.string :path, limit: 4096, index: true, null: false
      t.string :description
      t.boolean :hidden

      t.timestamps
    end
  end
end
