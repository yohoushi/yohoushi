class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string :type # STI
      t.string :fullpath, limit: 4096, index: true, null: false
      t.string :description
      t.boolean :hidden

      t.timestamps
    end
  end
end
