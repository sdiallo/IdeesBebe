class AddTimestampsToProductAsset < ActiveRecord::Migration
  def change
    change_table :product_assets do |t|
      t.timestamps
    end
  end
end
