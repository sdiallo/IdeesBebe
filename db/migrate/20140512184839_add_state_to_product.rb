class AddStateToProduct < ActiveRecord::Migration
  def change
    add_column :products, :state, :integer, default: 0
  end
end
