class Section < Node
  # Destroy if a section does not have any children
  def destroy_if_childless
    self.destroy unless self.children.present?
  end
end
