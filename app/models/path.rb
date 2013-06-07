class Path < ActiveRecord::Base
  has_ancestry

  # @return id of the direct parent
  def self.create_parents(fullpath)
    if (dirname = File.dirname(fullpath)) == '.'
      parent = Directory.select(:id).where(:fullpath => '/').first || Directory.create(:fullpath => '/')
    else
      parent_id = create_parents(dirname)
      # NOTE: where(:fullpath, :parent_id).first_or_create can not be used since :parent_id is not a real column
      parent = Directory.select(:id).where(:fullpath => dirname).first || Directory.create(:fullpath => dirname, :parent_id => parent_id)
    end
    parent.id
  end
end
