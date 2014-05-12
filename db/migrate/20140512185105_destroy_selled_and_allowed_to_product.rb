class DestroySelledAndAllowedToProduct < ActiveRecord::Migration
  def change
    remove_column :products, :selled, :boolean
    remove_column :products, :allowed, :boolean
  end
end
