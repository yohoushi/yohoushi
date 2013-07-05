class Section < Node
  # Destory all childless sections
  def self.destroy_all_childless(batch_size: 1000)
    Section.select('id, ancestry').find_each(batch_size: batch_size) do |section|
      section.destroy unless section.children.first.present?
    end
  end
end
