class AddSenderAndReceiverToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :sender_id, :integer
    add_column :messages, :receiver_id, :integer

    add_index :messages, :sender_id
    add_index :messages, :receiver_id

    remove_column :messages, :user_id
  end
end
