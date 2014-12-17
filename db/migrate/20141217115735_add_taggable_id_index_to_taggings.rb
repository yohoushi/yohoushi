class AddTaggableIdIndexToTaggings < ActiveRecord::Migration
  def change
    add_index :taggings, [:taggable_id, :taggable_type, :context, :tagger_id, :tagger_type], :name => :index_taggings_on_taggable_id
  end
end
