class DeleteProductIdToAsset < ActiveRecord::Migration
  def change
    remove_column :assets, :product_id, :integer
  end
end
