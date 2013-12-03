class AddMainToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :main_category_id, :integer, default: nil
  end
end
