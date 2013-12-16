module Slugable
  extend ActiveSupport::Concern

  # User slugged the username field. Product and Category take name field
  def to_slug
    slugged = self.instance_of?(User) ? self.username.parameterize : self.name.parameterize
    self.slug = slugged.parameterize
  end
end