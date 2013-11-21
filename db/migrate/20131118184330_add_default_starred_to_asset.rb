class AddDefaultStarredToAsset < ActiveRecord::Migration
  def change
    change_column :assets, :starred, :boolean, :default => false
  end
end
