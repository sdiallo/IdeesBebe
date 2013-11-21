class AddPolymorphicToAsset < ActiveRecord::Migration
  def change
    remove_column :products, :star_id
    add_column :assets, :referencer_id, :integer
    add_column :assets, :referencer_type, :string
    add_column :assets, :starred, :boolean
  end
end
