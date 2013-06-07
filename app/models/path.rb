class Path < ActiveRecord::Base
  has_ancestry

  # @return id of the direct parent
  def self.create_parents(fullpath)
    return nil if (dirname = File.dirname(fullpath)) == '.'
    parent = create_parents(dirname)
    # NOTE: where(:fullpath, :parent_id).first_or_create can not be used since :parent_id is not a real column
    Directory.select(:id).where(:fullpath => dirname).first || Directory.create(:fullpath => dirname, :parent => parent)
  end
end
