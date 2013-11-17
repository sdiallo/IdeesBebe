class AddStarToProduct < ActiveRecord::Migration
  def change
    add_column :products, :star_id, :integer
  end
end
