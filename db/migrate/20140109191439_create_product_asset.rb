class CreateProductAsset < ActiveRecord::Migration
  def change
    create_table :product_assets do |t|
      t.references :product, index: true
      t.string :file
      t.boolean :starred
    end
  end
end
