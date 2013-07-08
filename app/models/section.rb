class Section < Node
  # Destory all childless sections
  # NOTE: This method is not called from anywhere, but let me keep because I may use this from rails console
  def self.destroy_all_childless(batch_size: 1000)
    Section.select('id, ancestry').find_each(batch_size: batch_size) do |section|
      section.destroy_ancestors unless section.children.first.present?
    end
  end
end
