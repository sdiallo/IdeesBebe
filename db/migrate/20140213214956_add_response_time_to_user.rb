class AddResponseTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :response_time, :integer, default: 0
  end
end
