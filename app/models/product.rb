class Product < ActiveRecord::Base
  belongs_to :user

  include Slugable

  before_save :to_slug, :if => :name_changed?
end
