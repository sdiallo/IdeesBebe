class AddProductAndReceiverToMessage < ActiveRecord::Migration
  def change
    add_reference :messages, :product, index: true
    add_column :messages, :receiver_id, :integer, index: true
    remove_column :messages, :conversation_id
    drop_table :conversations
  end
end
