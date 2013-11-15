class Product < ActiveRecord::Base
  belongs_to :user

  include Slugable

  validates :name, length: { minimum: 2, maximum: 60 }, uniqueness: { message: "Ce nom de produit est déjà utilisé"}
  validates :description, length: { maximum: 140 }, allow_blank: true
  before_save :to_slug, :if => :name_changed?
end
