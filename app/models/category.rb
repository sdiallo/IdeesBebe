# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  slug             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  main_category_id :integer
#

class Category < ActiveRecord::Base
  has_many :products
  has_many :subcategories, class_name: 'Category',
                          foreign_key: 'main_category_id'
 
  belongs_to :main_category, class_name: 'Category'

  include Slugable

  before_save :to_slug, if: :name_changed?

  def all_products
    return products unless subcategories.any?
    Product
      .select('categories.name as category_name, categories.slug as category_slug, products.*')
      .where(category_id: subcategories.pluck(:id))
      .joins(:category)
      .order('created_at DESC')
  end

  class << self

    def main_categories
      Category.where(main_category_id: nil)
    end
  end
end
