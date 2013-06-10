class Path < ActiveRecord::Base
  has_ancestry

  def root?
    path == "/"
  end

  def graph?
    type == "Graph"
  end

  def directory?
    type == "Directory"
  end

  # @return id of the direct parent
  def self.create_parents(path)
    if (dirname = File.dirname(path)) == '.'
      parent = Directory.select(:id).where(:path => '/').first || Directory.create(:path => '/')
    else
      parent_id = create_parents(dirname)
      # NOTE: where(:path, :parent_id).first_or_create can not be used since :parent_id is not a real column
      parent = Directory.select(:id).where(:path => dirname).first || Directory.create(:path => dirname, :parent_id => parent_id)
    end
    parent.id
  end
end
