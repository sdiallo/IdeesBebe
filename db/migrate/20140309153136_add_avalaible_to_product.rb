class AddAvalaibleToProduct < ActiveRecord::Migration
  def change
    add_column :products, :selled, :boolean, default: false
  end
end
