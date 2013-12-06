class ChangeAssetToFileFromAsset < ActiveRecord::Migration
  def change
    rename_column :assets, :asset, :file
  end
end
