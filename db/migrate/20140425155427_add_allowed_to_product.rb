class AddAllowedToProduct < ActiveRecord::Migration
  def change
    add_column :products, :allowed, :boolean, default: true
  end
end
