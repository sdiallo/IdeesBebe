class RemoveProductToMessage < ActiveRecord::Migration
  def change
    remove_reference :messages, :product, index: true
  end
end
