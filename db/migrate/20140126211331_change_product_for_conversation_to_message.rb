class ChangeProductForConversationToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :conversation_id, :integer

    add_index :messages, :conversation_id

    remove_column :messages, :product_id
  end
end
