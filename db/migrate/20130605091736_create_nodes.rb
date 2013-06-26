class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :type # STI
      t.string :path, limit: 255, index: true, null: false, collation: 'utf8_bin'
      t.string :description
      t.boolean :hidden
      t.boolean :complex

      t.timestamps
    end
  end
end
